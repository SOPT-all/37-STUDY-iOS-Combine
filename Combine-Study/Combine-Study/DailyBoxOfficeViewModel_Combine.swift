//
//  DailyBoxOfficeViewModel.swift
//  Combine-Study
//
//  Created by 이나연 on 12/16/25.
//

import Combine
import Foundation

class DailyBoxOfficeViewModel_Combine: ViewModelType {
    private let networkService = CombineBoxOfficeService()
    private var cancellables: Set<AnyCancellable> = []
    @Published private(set) var dailyBoxOfficeList: [DailyBoxOfficeModel] = []
    
    enum Input {
        case viewDidLoad
    }
    
    func action(_ trigger: Input) {
        switch trigger {
        case .viewDidLoad:
            fetchDailyBoxOffice()
        }
    }
    
    private func fetchDailyBoxOffice() {
        networkService.fetchDailyBoxOffice()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print(error)
                    }
                },
                receiveValue: { [weak self] list in
                    self?.dailyBoxOfficeList = list
                }
            )
            .store(in: &cancellables)
    }
    
}
