//
//  File.swift
//  Data
//
//  Created by 김호성 on 2025.12.16.
//

import Foundation

import Moya

enum MovieAPI {
    case fetchBoxOfficeRanking(key: String, date: String)
}

extension MovieAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://kobis.or.kr")!
    }
    
    var path: String {
        return "/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchBoxOfficeRanking:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchBoxOfficeRanking(let key, let date):
            return .requestParameters(parameters: [
                "key": key,
                "targetDt": date
            ], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
