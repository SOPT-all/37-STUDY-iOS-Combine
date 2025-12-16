//
//  MovieService.swift
//  Combine-Study
//
//  Created by 김나연 on 12/16/25.
//

import Foundation

final class MovieService {
    static let shared = MovieService()
    private init() {}
    
    func makeRequest() -> URLRequest? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        var urlString = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=c06cf35df72346791f337ce75080763e&"
        
        if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) {
            let yesterdayString = formatter.string(from: yesterday)
            if let encoded = yesterdayString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                urlString += "targetDt=\(encoded)"
            }
        }
        
        guard let url = URL(string: urlString) else {return nil}
            
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }

    func fetchMovieRankList() async throws -> [MovieModel] {
        guard let request = makeRequest() else {
            throw NetworkError.requestEncodingError
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.responseError
        }
        do {
            let decoded = try JSONDecoder().decode(MovieResponseDTO.self, from: data)
            return decoded.boxOfficeResult.dailyBoxOfficeList.map { MovieModel(from: $0) }
        } catch {
            print("디코딩 실패:", error)
            throw NetworkError.responseDecodingError
        }
    }
}
