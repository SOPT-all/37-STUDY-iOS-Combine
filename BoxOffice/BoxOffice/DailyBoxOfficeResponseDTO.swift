//
//  DailyBoxOfficeResponseDTO.swift
//  BoxOffice
//
//  Created by 안치욱 on 12/17/25.
//


import Foundation

struct DailyBoxOfficeResponseDTO: Decodable {
    let boxOfficeResult: BoxOfficeResultDTO
}

struct BoxOfficeResultDTO: Decodable {
    let dailyBoxOfficeList: [DailyBoxOfficeItemDTO]
}

struct DailyBoxOfficeItemDTO: Decodable {
    let movieCd: String
    let movieNm: String
    let rank: String
    let openDt: String?
    let audiAcc: String
}