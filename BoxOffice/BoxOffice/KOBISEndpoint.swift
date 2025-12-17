//
//  KOBISEndpoint.swift
//  BoxOffice
//
//  Created by 안치욱 on 12/17/25.
//


import Foundation

enum KOBISEndpoint {
    case dailyBoxOffice(date: String)

    var url: URL {
        var c = URLComponents()
        c.scheme = "https"
        c.host = "kobis.or.kr"
        c.path = "/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"

        let key = ""

        c.queryItems = [
            .init(name: "key", value: key),
            .init(name: "targetDt", value: targetDt)
        ]

        guard let url = c.url else { fatalError("Invalid KOBIS URL") }
        return url
    }

    private var targetDt: String {
        switch self {
        case .dailyBoxOffice(let date): return date
        }
    }
}
