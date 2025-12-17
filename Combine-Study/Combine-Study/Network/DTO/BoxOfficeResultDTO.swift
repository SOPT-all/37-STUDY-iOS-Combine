//
//  BoxOfficeResultDTO.swift
//  Combine-Study
//
//  Created by 이나연 on 12/16/25.
//

import Foundation

struct DailyBoxOfficeResponseDTO: Decodable {
    let boxOfficeResult: BoxOfficeResultDTO
}

struct BoxOfficeResultDTO: Decodable {
    let boxofficeType: String
    let showRange: String
    let dailyBoxOfficeList: [DailyBoxOfficeDTO]
}

struct DailyBoxOfficeDTO: Decodable {
    let rnum: String
    let rank: String
    let rankInten: String
    let rankOldAndNew: String
    let movieCd: String
    let movieNm: String
    let openDt: String
    let salesAmt: String
    let salesShare: String
    let salesInten: String
    let salesChange: String
    let salesAcc: String
    let audiCnt: String
    let audiInten: String
    let audiChange: String
    let audiAcc: String
    let scrnCnt: String
    let showCnt: String
    
    func toEntity() -> DailyBoxOfficeModel {
        return .init(
            rank: self.rank,
            movieNm: self.movieNm,
            movieCd: self.movieCd,
            openDt: self.openDt
        )
    }
}
