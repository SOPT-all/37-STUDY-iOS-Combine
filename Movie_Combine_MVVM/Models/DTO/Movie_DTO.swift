//
//  Movie-DTO.swift
//  Movie_Combine_MVVM
//
//  Created by 이승준 on 12/17/25.
//

import Foundation

struct MovieListResponse: Codable {
    let movieListResult: MovieListResult
}

struct MovieListResult: Codable {
    let totCnt: Int
    let source: String
    let movieList: [Movie]
}

struct Movie: Codable {
    let movieCd: String
    let movieNm: String
    let movieNmEn: String?
    let prdtYear: String
    let openDt: String
    let typeNm: String
    let prdtStatNm: String
    let nationAlt: String
    let genreAlt: String
    let repNationNm: String
    let repGenreNm: String
    let directors: [Director]
    let companys: [Company]
    
    var bookMark: Bool = false
    
    enum CodingKeys: CodingKey {
        case movieCd
        case movieNm
        case movieNmEn
        case prdtYear
        case openDt
        case typeNm
        case prdtStatNm
        case nationAlt
        case genreAlt
        case repNationNm
        case repGenreNm
        case directors
        case companys
    }
}

struct Director: Codable {
    let peopleNm: String
}

struct Company: Codable {
    let companyCd: String
    let companyNm: String
}
