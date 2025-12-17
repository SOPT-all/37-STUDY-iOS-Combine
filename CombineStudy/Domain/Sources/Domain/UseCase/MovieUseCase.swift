//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2025.12.16.
//

import Combine

public protocol MovieUseCase {
    func fetchBoxOfficeRanking(date: String) -> AnyPublisher<BoxOfficeEntity, Error>
}

public final class DefaultMovieUseCase: MovieUseCase {
    
    private let movieRepository: MovieRepository
    
    public init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    public func fetchBoxOfficeRanking(date: String) -> AnyPublisher<BoxOfficeEntity, any Error> {
        return movieRepository.fetchBoxOfficeRanking(date: date)
    }
}
