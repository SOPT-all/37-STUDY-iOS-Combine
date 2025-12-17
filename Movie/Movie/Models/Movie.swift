//
//  Movie.swift
//  Movie
//
//  Created by 어재선 on 12/17/25.
//
    
import Foundation

struct MovieInfoResponse: Decodable {
    let movieInfoResult: MovieInfoResult
}

struct MovieInfoResult: Decodable {
    let movieInfo: MovieInfo
    let source: String
}

struct MovieInfo: Decodable {
    let movieCd: String
    let movieNm: String
    let movieNmEn: String
    let movieNmOg: String
    let showTm: String
    let prdtYear: String
    let openDt: String
    let prdtStatNm: String
    let typeNm: String
    let nations: [Nation]
    let genres: [Genre]
    let directors: [DirectorInfo]
    let actors: [Actor]
    let showTypes: [ShowType]
    let companys: [CompanyInfo]
    let audits: [Audit]
    let staffs: [Staff]
}

struct Nation: Decodable {
    let nationNm: String
}

struct Genre: Decodable {
    let genreNm: String
}

struct DirectorInfo: Decodable {
    let peopleNm: String
    let peopleNmEn: String
}

struct Actor: Decodable {
    let peopleNm: String
    let peopleNmEn: String
    let cast: String
    let castEn: String
}

struct ShowType: Decodable {
    let showTypeGroupNm: String
    let showTypeNm: String
}

struct CompanyInfo: Decodable {
    let companyCd: String
    let companyNm: String
    let companyNmEn: String
    let companyPartNm: String
}

struct Audit: Decodable {
    let auditNo: String
    let watchGradeNm: String
}

struct Staff: Decodable {
    let peopleNm: String?
    let peopleNmEn: String?
    let staffRoleNm: String?
}
