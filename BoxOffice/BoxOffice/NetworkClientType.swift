//
//  NetworkClientType.swift
//  BoxOffice
//
//  Created by 안치욱 on 12/17/25.
//


import Foundation
import Combine

protocol NetworkClientType {
    func get<T: Decodable>(_ url: URL, type: T.Type) -> AnyPublisher<T, Error>
}

final class NetworkClient: NetworkClientType {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    func get<T: Decodable>(_ url: URL, type: T.Type) -> AnyPublisher<T, Error> {
        session.dataTaskPublisher(for: url)
            .tryMap { output in
                if let http = output.response as? HTTPURLResponse,
                   !(200...299).contains(http.statusCode) {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}