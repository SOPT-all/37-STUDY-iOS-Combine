//
//  NetworkProvider.swift
//  Combine_Study
//
//  Created by 임소은 on 12/16/25.
//

import Foundation
import Combine

protocol NetworkProviding {
    func request<T: Decodable>(_ target: TargetType) -> AnyPublisher<T, NetworkError>
}

final class NetworkProvider: NetworkProviding {

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }

    func request<T: Decodable>(_ target: TargetType) -> AnyPublisher<T, NetworkError> {

        guard var components = URLComponents(
            url: target.baseURL.appendingPathComponent(target.path),
            resolvingAgainstBaseURL: false
        ) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        components.queryItems = target.queryItems

        guard let url = components.url else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }

        var req = URLRequest(url: url, timeoutInterval: target.timeout)
        req.httpMethod = target.method.rawValue
        target.headers.forEach { req.setValue($0.value, forHTTPHeaderField: $0.key) }

        return session.dataTaskPublisher(for: req)
            .mapError { NetworkError.unknown($0) }
            .tryMap { data, response -> Data in
                guard let http = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                guard (200...299).contains(http.statusCode) else {
                    throw NetworkError.httpError(statusCode: http.statusCode)
                }

                if let fault = try? self.decoder.decode(KobisFaultResponseDTO.self, from: data) {
                    throw NetworkError.apiError(message: fault.faultInfo.message)
                }

                return data
            }
            .mapError { ($0 as? NetworkError) ?? .unknown($0) }
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                if error is DecodingError { return .decodingFailed }
                return (error as? NetworkError) ?? .unknown(error)
            }
            .eraseToAnyPublisher()
    }
}
