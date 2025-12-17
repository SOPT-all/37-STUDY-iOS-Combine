//
//  DIContainer.swift
//  CollaborativeComputingLab
//
//  Created by 김호성 on 2025.03.04.
//

import Data
import Domain
import Presentation

import UIKit

protocol AppFactory: ViewControllerFactory, MovieFactory { }
typealias DIContainer = AppFactory

final class DefaultDIContainer: DIContainer {
    
    // MARK: - Root Dependency
    private lazy var movieService: MovieService = DefaultMovieService(apiKey: Bundle.main.apiKey!)
    
    // MARK: - ViewControllerFactory
    func buildMainViewController() -> MainViewController {
        return MainViewController(movieViewModel: buildMovieViewModel())
    }
    
    // MARK: - Root Dependency Injection
    func buildMovieRepository() -> MovieRepository {
        return buildMovieRepository(movieService: movieService)
    }
}
