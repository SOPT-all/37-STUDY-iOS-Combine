//
//  BoxOfficeResponse.swift
//  Combine-Study
//
//  Created by 이상수 on 12/17/25.
//

extension MovieAPI {
    
    struct BoxOfficeResponse: Decodable {
        let boxOfficeResult: BoxOfficeResult
    }
    
    struct BoxOfficeResult: Decodable {
        let boxofficeType: String
        let showRange: String
        let dailyBoxOfficeList: [DailyBoxOffice]
    }
    
    struct DailyBoxOffice: Decodable {
        let rank: String
        let rankInten: String
        let movieNm: String
        let openDt: String
        let salesAcc: String
        let audiCnt: String
        let audiAcc: String
    }
    
}
