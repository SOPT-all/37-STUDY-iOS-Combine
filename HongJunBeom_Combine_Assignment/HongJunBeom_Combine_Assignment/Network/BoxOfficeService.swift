//
//  BoxOfficeService.swift
//  HongJunBeom_Combine_Assignment
//
//  Created by 홍준범 on 12/17/25.
//

import Foundation
import Combine

final class BoxOfficeService {
    static let shared = BoxOfficeService()
    private init() {}
    
    private let baseURL = "https://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
    
    private let apiKey: String = {
        guard let key = Bundle.main.object(
            forInfoDictionaryKey: "KOBIS_API_KEY"
        ) as? String else {
            fatalError("❌ KOBIS_API_KEY not found")
        }
        return key
    }()
    
    func fetchDailyBoxOffice(date: String) -> AnyPublisher<[DailyBoxOffice], NetworkError> {
        guard var components = URLComponents(string: baseURL) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        components.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "targetDt", value: date)
        ]
        
       guard let url = components.url else {
           return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
                   .tryMap { output -> Data in
                       guard let response = output.response as? HTTPURLResponse else {
                           throw NetworkError.unknownError
                       }

                       switch response.statusCode {
                       case 200...299:
                           return output.data
                       case 500...599:
                           throw NetworkError.internalServerError
                       default:
                           throw NetworkError.clientError(statusCode: response.statusCode)
                       }
                   }
                   .decode(type: BoxOfficeResponse.self, decoder: JSONDecoder())
                   .map { $0.boxOfficeResult.dailyBoxOfficeList }
                   .mapError { error -> NetworkError in
                       if let networkError = error as? NetworkError { return networkError }
                       if error is DecodingError { return .responseDecodingError }
                       if (error as? URLError) != nil { return .unknownError }
                       return .unknownError
                   }
                   .receive(on: DispatchQueue.main)
                   .eraseToAnyPublisher()
           }
}
