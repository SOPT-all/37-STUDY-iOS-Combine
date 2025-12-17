
import Foundation
import Combine

protocol BoxOfficeServicing {
    func fetchDailyBoxOffice(targetDate: Date) -> AnyPublisher<[DailyBoxOfficeItem], Error>
}

final class KobisBoxOfficeService: BoxOfficeServicing {

    private let apiKey: String
    private let session: URLSession

    init(apiKey: String, session: URLSession = .shared) {
        self.apiKey = apiKey
        self.session = session
    }

    func fetchDailyBoxOffice(targetDate: Date) -> AnyPublisher<[DailyBoxOfficeItem], Error> {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "yyyyMMdd"
        let targetDt = f.string(from: targetDate)

        // http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json
        var components = URLComponents(string: "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json")
        components?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "targetDt", value: targetDt)
        ]

        guard let url = components?.url else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: DailyBoxOfficeResponseDTO.self, decoder: JSONDecoder())
            .map { $0.boxOfficeResult.dailyBoxOfficeList.map(DailyBoxOfficeItem.init(dto:)) }
            .eraseToAnyPublisher()
    }
}
