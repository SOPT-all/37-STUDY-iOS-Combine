//
//  People_DTO.swift
//  Movie_Combine_MVVM
//
//  Created by 이승준 on 12/17/25.
//

import Foundation

struct PeopleListResponse: Codable {
    let peopleListResult: PeopleListResult
}

struct PeopleListResult: Codable {
    let totCnt: Int
    let source: String
    let peopleList: [People]
}

struct People: Codable {
    let peopleCd: String
    let peopleNm: String
    let peopleNmEn: String
    let repRoleNm: String
    let filmoNames: String
}
