//
//  BoxOfficeViewModel.swift
//  Combine_Study
//
//  Created by 임소은 on 12/15/25.
//

import Foundation
import Combine

final class BoxOfficeViewModel: ObservableObject {

    @Published private(set) var items: [DailyBoxOfficeItem] = []
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?

    private let repo: BoxOfficeRepositoryProtocol
    private var bag = Set<AnyCancellable>()

    init(repo: BoxOfficeRepositoryProtocol = BoxOfficeRepository()) {
        self.repo = repo
    }

    func fetch(date: Date) {
        isLoading = true
        errorMessage = nil

        repo.fetchDailyBoxOffice(date: date)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                if case let .failure(err) = completion {
                    self.errorMessage = err.localizedDescription
                }
            } receiveValue: { [weak self] items in
                self?.items = items
            }
            .store(in: &bag)
    }
}
