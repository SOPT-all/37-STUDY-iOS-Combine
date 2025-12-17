//
//  MovieDTO.swift
//  movie
//
//  Created by sun on 12/17/25.
//

import Foundation

struct MovieResponseDTO: Codable {
    let boxOfficeResult: BoxOfficeResultDTO
}

struct BoxOfficeResultDTO: Codable {
    let dailyBoxOfficeList: [MovieInfoDTO]
}

struct MovieInfoDTO: Codable {
    let rank: String
    let movieNm: String
    let audiAcc: String
}

extension MovieInfo {
    init(dto: MovieInfoDTO) {
        self.rank = Int(dto.rank) ?? 0
        self.title = dto.movieNm
        self.audienceAccumulated = dto.audiAcc
    }
}
