//
//  MovieService.swift
//  Movie
//
//  Created by 어재선 on 12/17/25.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
}

final class MovieService {
    private let baseURL = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList"

    private let apiKey: String
    
    init() {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "MOVIEAPI_KEY") as? String else {
            fatalError("MOVIEAPI_KEY not set in plist")
        }
        self.apiKey = apiKey
    }
    
    func fetchMovies(targetDt: Int = 20250101) -> AnyPublisher<[DailyBoxOffice], NetworkError> {
        guard var components = URLComponents(string: baseURL) else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "targetDt", value: "\(targetDt)")
        ]
        
        guard let url = components.url else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { _ in NetworkError.invalidResponse }
            .map(\.data)
            .decode(type: BoxOfficeResponse.self, decoder: JSONDecoder())
            .mapError { NetworkError.decodingError($0) }
            .map(\.boxOfficeResult.dailyBoxOfficeList)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
