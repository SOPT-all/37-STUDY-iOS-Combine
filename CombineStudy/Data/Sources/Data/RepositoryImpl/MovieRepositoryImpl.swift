//
//  File.swift
//  Data
//
//  Created by 김호성 on 2025.12.16.
//

import Domain

import Combine

public final class DefaultMovieRepository: MovieRepository {
    
    private let movieService: MovieService
    
    public init(movieService: MovieService) {
        self.movieService = movieService
    }
    
    public func fetchBoxOfficeRanking(date: String) -> AnyPublisher<Domain.BoxOfficeEntity, any Error> {
        return movieService.fetchBoxOfficeRanking(date: date)
            .map(\.entity)
            .mapError({ $0 as Error })
            .eraseToAnyPublisher()
    }
}
