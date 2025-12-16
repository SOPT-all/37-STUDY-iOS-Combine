//
//  MovieData.swift
//  Combine-Study
//
//  Created by 김나연 on 12/16/25.
//

import Foundation

struct MovieModel: Codable {
    let rank: String
    let movieNm: String
    let openDt: String
    let audiCnt: String
    let audiAcc: String
}

extension MovieModel {
    init(from daily: DailyBoxOffice) {
        self.rank = daily.rank
        self.movieNm = daily.movieNm
        self.openDt = daily.openDt
        self.audiCnt = daily.audiCnt
        self.audiAcc = daily.audiAcc
    }
}
