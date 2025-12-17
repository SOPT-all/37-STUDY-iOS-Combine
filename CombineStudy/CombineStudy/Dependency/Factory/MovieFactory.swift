//
//  MovieFactory.swift
//  CombineStudy
//
//  Created by 김호성 on 2025.03.04.
//

import Data
import Domain
import Presentation

import Foundation

protocol MovieFactory {
    func buildMovieRepository() -> MovieRepository
    func buildMovieRepository(movieService: MovieService) -> MovieRepository
    
    func buildMovieUseCase() -> MovieUseCase
    func buildMovieUseCase(movieRepository: MovieRepository) -> MovieUseCase
    
    func buildMovieViewModel() -> MovieViewModel
    func buildMovieViewModel(movieUseCase: MovieUseCase) -> MovieViewModel
}

extension MovieFactory {
    func buildMovieRepository(movieService: MovieService) -> MovieRepository {
        return DefaultMovieRepository(movieService: movieService)
    }
    
    func buildMovieUseCase() -> MovieUseCase {
        return DefaultMovieUseCase(movieRepository: buildMovieRepository())
    }
    func buildMovieUseCase(movieRepository: MovieRepository) -> MovieUseCase {
        return DefaultMovieUseCase(movieRepository: movieRepository)
    }
    
    func buildMovieViewModel() -> MovieViewModel {
        return DefaultMovieViewModel(movieUseCase: buildMovieUseCase())
    }
    func buildMovieViewModel(movieUseCase: MovieUseCase) -> MovieViewModel {
        return DefaultMovieViewModel(movieUseCase: movieUseCase)
    }
}
