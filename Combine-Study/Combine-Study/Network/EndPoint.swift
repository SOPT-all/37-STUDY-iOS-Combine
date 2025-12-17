//
//  EndPoint.swift
//  Combine-Study
//
//  Created by 이나연 on 12/16/25.
//

import Foundation

enum EndPoint {
    case dailyBoxOffice
   
    var requestType: HTTPMethodType {
        switch self {
        case .dailyBoxOffice:
            return .get
        }
    }
    
    var url: String {
        switch self {
        case .dailyBoxOffice:
            return "/searchDailyBoxOfficeList.json"
        }
    }
    
    var header: [String: String] {
        switch self {
        case .dailyBoxOffice:
            return HeaderType.basic.value
        }
    }
    
    var queryParams: [String: String]? {
        switch self {
        case .dailyBoxOffice:
            return [
                "key": Bundle.main.infoDictionary?["API_KEY"] as! String,
                "targetDt": "20251215"
            ]
        }
    }
}
