//
//  KobisAPITarget.swift
//  Combine_Study
//
//  Created by 임소은 on 12/16/25.
//

import Foundation

enum KobisAPITarget: TargetType {

    case dailyBoxOffice(targetDt: String) // yyyyMMdd

    var baseURL: URL { URL(string: "http://www.kobis.or.kr")! }

    var path: String {
        switch self {
        case .dailyBoxOffice:
            return "/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
        }
    }

    var method: HTTPMethod { .get }

    var queryItems: [URLQueryItem] {
        switch self {
        case .dailyBoxOffice(let targetDt):
            return [
                .init(name: "key", value: AppConfig.kobisAPIKey),
                .init(name: "targetDt", value: targetDt)
            ]
        }
    }
}
