//
//  MovieDetailViewModel.swift
//  Movie
//
//  Created by 어재선 on 12/17/25.
//

import Foundation
import Combine

final class MovieDetailViewModel: ObservableObject {
    @Published var movieInfo: MovieInfo?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let movieService = MovieService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchMovieDetail(movieCd: String) {
        isLoading = true
        errorMessage = nil
        
        movieService.fetchMovieInfo(movieCd: movieCd)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] movieInfo in
                self?.movieInfo = movieInfo
            }
            .store(in: &cancellables)
    }
}
