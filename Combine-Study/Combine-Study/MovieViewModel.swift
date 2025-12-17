//
//  MovieViewModel.swift
//  Combine-Study
//
//  Created by 이상수 on 12/17/25.
//

import Combine

final class MovieViewModel {
   
    let movies = PassthroughSubject<[MovieAPI.DailyBoxOffice], Never>()
    let isLoading = PassthroughSubject<Bool, Never>()

    func load() {
        isLoading.send(true)

        Task {
            do {
                let result = try await MovieAPI.fetch()
                movies.send(result)
            } catch {
                print("에러에러에러에러: \(error)")
            }
            isLoading.send(false)
        }
    }
    
}
