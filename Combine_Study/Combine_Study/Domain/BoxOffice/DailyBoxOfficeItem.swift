//
//  DailyBoxOfficeItem.swift
//  Combine_Study
//
//  Created by 임소은 on 12/15/25.
//

import Foundation

struct DailyBoxOfficeItem: Identifiable, Hashable {
    let id: String
    let rank: String
    let movieName: String
    let openDate: String
    let audienceAcc: String

    init(dto: DailyBoxOfficeResponseDTO.DailyBoxOfficeDTO) {
        id = dto.movieCd
        rank = dto.rank
        movieName = dto.movieNm
        openDate = dto.openDt
        audienceAcc = dto.audiAcc
    }
}
