//
//  MovieAPI.swift
//  Combine-Study
//
//  Created by 이상수 on 12/17/25.
//

import UIKit

struct MovieAPI {

    static func fetch() async throws -> [DailyBoxOffice] {
        let fetched: BoxOfficeResponse = try await APIHelper.fetch(url: url)
        return fetched.boxOfficeResult.dailyBoxOfficeList
    }

}

extension MovieAPI {

    private static var url: URL? {
        let param = params
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
        let url = Constants.baseURL + "?" + param
        return URL(string: url)
    }

    private static var params: [String: Any] {
        [
            "key": Constants.apiKey,
            "targetDt": "20251216",
            "repNationCd": "K"
        ]
    }

}

extension MovieAPI {

    private enum Constants {
        static let apiKey = "1e0e28f5603a7ff6e4038ebd37d0fdd7"
        static let baseURL = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
    }

}
