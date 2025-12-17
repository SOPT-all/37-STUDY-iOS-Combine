//
//  MovieService.swift
//  movie
//
//  Created by sun on 12/17/25.
//

import Foundation

final class MovieService: BaseService<MovieTarget> {

    func fetchDailyBoxOffice(targetDate: String) async throws -> [MovieInfoDTO] {
        let dto: MovieResponseDTO = try await requestRaw(with: .dailyBoxOffice(targetDate: targetDate))
        return dto.boxOfficeResult.dailyBoxOfficeList
    }
}

