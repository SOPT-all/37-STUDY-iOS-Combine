//
//  DailyBoxOfficeViewModel.swift
//  HongJunBeom_Combine_Assignment
//
//  Created by 홍준범 on 12/17/25.
//

import Foundation
import Combine

final class DailyBoxOfficeViewModel {
    struct Input {
        let inquiryButtonTapped: AnyPublisher<Date, Never>
    }
    
    struct Output {
        let boxOfficeList: AnyPublisher<[DailyBoxOffice], Never>
        let isLoading: AnyPublisher<Bool, Never>
    }
    
    private let boxOfficeService: BoxOfficeService
    private var cancellables = Set<AnyCancellable>()
    
    init(boxOfficeService: BoxOfficeService = .shared) {
        self.boxOfficeService = boxOfficeService
    }
    
    func transform(input: Input) -> Output {
        let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
        let boxOfficeListSubject = CurrentValueSubject<[DailyBoxOffice], Never>([])
        
        input.inquiryButtonTapped
            .map { date -> String in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd"
                formatter.locale = Locale(identifier: "ko_KR")
                return formatter.string(from: date)
            }
            .handleEvents(receiveOutput: { _ in
                isLoadingSubject.send(true)
            })
            .flatMap { [boxOfficeService] dateString in
                boxOfficeService.fetchDailyBoxOffice(date: dateString)
                    .catch { _ in Just([])}
            }
            .sink { movies in
                isLoadingSubject.send(false)
                boxOfficeListSubject.send(movies)
            }
            .store(in: &cancellables)
        
        return Output(boxOfficeList: boxOfficeListSubject.eraseToAnyPublisher(), isLoading: isLoadingSubject.eraseToAnyPublisher())
    }
}
