//
//  File.swift
//  Presentation
//
//  Created by 김호성 on 2025.12.16.
//

import Domain

import Combine
import Foundation

public protocol MovieViewModelInput {
    func fetchBoxOfficeRanking(date: DateComponents)
}

public protocol MovieViewModelOutput {
    var boxOfficeRanking: CurrentValueSubject<BoxOfficeEntity, Never> { get }
}

public protocol MovieViewModel: MovieViewModelInput, MovieViewModelOutput { }

public final class DefaultMovieViewModel: MovieViewModel {
    
    public var boxOfficeRanking: CurrentValueSubject<BoxOfficeEntity, Never> = .init(BoxOfficeEntity(ranking: []))
    
    private let movieUseCase: MovieUseCase
    
    private var cancellables = Set<AnyCancellable>()
    
    public init(movieUseCase: MovieUseCase) {
        self.movieUseCase = movieUseCase
    }
    
    public func fetchBoxOfficeRanking(date: DateComponents) {
        guard let dateString = date.date?.string(withFormat: "yyyyMMdd") else { return }
        movieUseCase.fetchBoxOfficeRanking(date: dateString)
            .manageThread()
            .sinkHandledCompletion(receiveValue: { [weak self] boxOfficeEntity in
                self?.boxOfficeRanking.value = boxOfficeEntity
            })
            .store(in: &cancellables)
    }
}
