//
//  MovieListViewModel.swift
//  Movie
//
//  Created by 어재선 on 12/17/25.
//

import Foundation
import Combine

final class MovieListViewModel: ObservableObject {
    @Published var movies: [DailyBoxOffice] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let movieService = MovieService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchMovies() {
        isLoading = true
        errorMessage = nil
        
        movieService.fetchMovies()
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
}
