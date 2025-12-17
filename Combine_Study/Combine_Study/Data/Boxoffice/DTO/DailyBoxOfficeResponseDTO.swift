//
//  DailyBoxOfficeResponseDTO.swift
//  Combine_Study
//
//  Created by 임소은 on 12/16/25.
//

import Foundation

struct DailyBoxOfficeResponseDTO: Decodable {
    let boxOfficeResult: BoxOfficeResultDTO

    struct BoxOfficeResultDTO: Decodable {
        let dailyBoxOfficeList: [DailyBoxOfficeDTO]
    }

    struct DailyBoxOfficeDTO: Decodable {
        let movieCd: String
        let rank: String
        let movieNm: String
        let openDt: String
        let audiAcc: String
    }
}
