//
//  File.swift
//  Data
//
//  Created by 김호성 on 2025.12.16.
//

import Domain

import Foundation

public struct BoxOfficeDTO: DTO {
    
    struct BoxOfficeResult: Codable {
        
        struct DailyBoxOffice: Codable {
            let rnum: String?
            let rank: String?
            let rankInten: String?
            let rankOldAndNew: String?
            let movieCd: String?
            let movieNm: String?
            let openDt: String?
            let salesAmt: String?
            let salesShare: String?
            let salesInten: String?
            let salesChange: String?
            let salesAcc: String?
            let audiCnt: String?
            let audiInten: String?
            let audiChange: String?
            let audiAcc: String?
            let scrnCnt: String?
            let showCnt: String?
        }
        
        let boxOfficeType: String?
        let showRange: String?
        let dailyBoxOfficeList: [DailyBoxOffice]?
    }
    
    let boxOfficeResult: BoxOfficeResult?
    
    init(entity: BoxOfficeEntity) {
        boxOfficeResult = BoxOfficeResult(
            boxOfficeType: nil,
            showRange: nil,
            dailyBoxOfficeList: entity.ranking.enumerated().map({ index, movieEntity in
                BoxOfficeResult.DailyBoxOffice(
                    rnum: nil,
                    rank: "\(index)",
                    rankInten: "\(movieEntity.rankVariance)",
                    rankOldAndNew: movieEntity.isNew ? "NEW" : "OLD",
                    movieCd: nil,
                    movieNm: movieEntity.name,
                    openDt: nil,
                    salesAmt: nil,
                    salesShare: nil,
                    salesInten: nil,
                    salesChange: nil,
                    salesAcc: nil,
                    audiCnt: nil,
                    audiInten: nil,
                    audiChange: nil,
                    audiAcc: "\(movieEntity.audience)",
                    scrnCnt: nil,
                    showCnt: nil
                )
            })
        )
    }
    
    var entity: BoxOfficeEntity {
        return BoxOfficeEntity(
            ranking: boxOfficeResult?.dailyBoxOfficeList?.compactMap({
                BoxOfficeEntity.MovieEntity(
                    name: $0.movieNm ?? "",
                    isNew: $0.rankOldAndNew == "NEW",
                    rankVariance: Int($0.rankInten ?? "") ?? 0,
                    audience: Int($0.audiAcc ?? "") ?? 0
                )
            }) ?? []
        )
    }
}
