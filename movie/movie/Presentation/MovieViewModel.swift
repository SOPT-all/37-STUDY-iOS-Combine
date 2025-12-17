//
//  MovieViewModel.swift
//  movie
//
//  Created by sun on 12/17/25.
//

import Combine
import Foundation

final class MovieViewModel {

    @Published private(set) var movies: [MovieInfo] = []
    @Published private(set) var errorMessage: String? = nil

    private let service = MovieService()
    private var cancellables = Set<AnyCancellable>()

    func fetch(targetDate: String) {
        Future<[MovieInfo], Error> { [service] promise in
            Task {
                do {
                    let dto = try await service.fetchDailyBoxOffice(targetDate: targetDate)
                    promise(.success(dto.map { MovieInfo(dto: $0) }))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] movies in
            self?.errorMessage = nil
            self?.movies = movies
        }
        .store(in: &cancellables)
    }
}
