//
//  MovieTarget.swift
//  movie
//
//  Created by sun on 12/17/25.
//

import Foundation

enum MovieTarget {
    case dailyBoxOffice(targetDate: String)
}

extension MovieTarget: TargetType {

    var baseURL: String { Environment.baseURL }

    var path: String {
        switch self {
        case .dailyBoxOffice:
            return "/boxoffice/searchDailyBoxOfficeList.json"
        }
    }

    var method: HTTPMethod { .get }

    var task: NetworkTask {
        switch self {
        case .dailyBoxOffice(let targetDate):
            return .requestParameters(
                parameters: [
                    "key": Environment.kobisAPIKey,
                    "targetDt": targetDate
                ],
                encoding: .queryString
            )
        }
    }

    var headers: HeaderField { .contentTypeJSON }
}
