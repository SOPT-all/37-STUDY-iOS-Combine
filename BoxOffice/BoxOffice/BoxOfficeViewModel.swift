//
//  BoxOfficeViewModel.swift
//  BoxOffice
//
//  Created by 안치욱 on 12/17/25.
//


import Foundation
import Combine

@MainActor
final class BoxOfficeViewModel: ObservableObject {

    @Published private(set) var movies: [BoxOfficeMovie] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?

    let load = PassthroughSubject<String, Never>()

    private let repo: BoxOfficeRepositoryType
    private var cancellables = Set<AnyCancellable>()

    init(repo: BoxOfficeRepositoryType) {
        self.repo = repo
        bind()
    }

    private func bind() {
        load
            .removeDuplicates()
            .handleEvents(receiveOutput: { [weak self] _ in
                self?.isLoading = true
                self?.errorMessage = nil
            })
            .flatMap { [repo] date in
                repo.fetchDaily(date: date)
                    .map(Result.success)
                    .catch { Just(Result.failure($0)) }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .success(let movies):
                    self.movies = movies
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
            .store(in: &cancellables)
    }
}
