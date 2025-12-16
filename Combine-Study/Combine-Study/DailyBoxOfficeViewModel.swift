//
//  DailyBoxOfficeViewModel.swift
//  Combine-Study
//
//  Created by 이나연 on 12/16/25.
//

import Foundation

class DailyBoxOfficeViewModel: ViewModelType {
    private let networkService = DefaultBoxOfficeService()
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
        Task { @MainActor in
            do {
                let result = try await networkService.fetchDailyBoxOffice()
                self.dailyBoxOfficeList = result
            }
            catch {
                print(error)
            }
        }
    }
    
}
