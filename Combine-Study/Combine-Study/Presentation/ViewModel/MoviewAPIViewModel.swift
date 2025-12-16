//
//  MoviewAPIViewModel.swift
//  Combine-Study
//
//  Created by 김나연 on 12/16/25.
//

import UIKit

import Combine

final class MoviewAPIViewModel {
    struct Input {
        let viewWillAppear: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let movies: AnyPublisher<[MovieModel], Never>
        let isLoading: AnyPublisher<Bool, Never>
        let error: AnyPublisher<String?, Never>
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let movieSubject = CurrentValueSubject<[MovieModel], Never>([])
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject = CurrentValueSubject<String?, Never>(nil)
    
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .sink { [weak self] _ in
                self?.fetchMovies()
            }
            .store(in: &cancellables)
        
        return Output(
            movies: movieSubject.eraseToAnyPublisher(), isLoading: isLoadingSubject.eraseToAnyPublisher(), error: errorSubject.eraseToAnyPublisher()
            )
    }
    
    private func fetchMovies() {
        isLoadingSubject.send(true)
        
        Task {
            do {
                let movies = try await MovieService.shared.fetchMovieRankList()
                movieSubject.send(movies)
                isLoadingSubject.send(false)
            } catch {
                errorSubject.send("데이터 로딩 실패: \(error.localizedDescription)")
                isLoadingSubject.send(false)
            }
        }
    }
}
