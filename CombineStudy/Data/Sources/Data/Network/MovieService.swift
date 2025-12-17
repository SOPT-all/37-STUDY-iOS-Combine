//
//  File.swift
//  Data
//
//  Created by 김호성 on 2025.12.16.
//

import Combine

import CombineMoya
import Moya

public protocol MovieService {
    func fetchBoxOfficeRanking(date: String) -> AnyPublisher<BoxOfficeDTO, MoyaError>
}

public final class DefaultMovieService: MovieService {
    private let provider = MoyaProvider<MovieAPI>()
    private let apiKey: String
    
    public init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    public func fetchBoxOfficeRanking(date: String) -> AnyPublisher<BoxOfficeDTO, MoyaError> {
        return provider.requestPublisher(.fetchBoxOfficeRanking(key: apiKey, date: date))
            .map(BoxOfficeDTO.self)
    }
}
