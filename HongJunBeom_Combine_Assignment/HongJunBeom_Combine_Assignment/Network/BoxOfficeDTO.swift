//
//  BoxOfficeDTO.swift
//  HongJunBeom_Combine_Assignment
//
//  Created by 홍준범 on 12/17/25.
//

import Foundation

struct BoxOfficeResponse: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let boxofficeType: String
    let showRange: String
    let dailyBoxOfficeList: [DailyBoxOffice]
}

struct DailyBoxOffice: Decodable {
    let rnum: String            // 순번
        let rank: String            // 순위
        let rankInten: String       // 순위 증감
        let rankOldAndNew: String   // 신규진입 여부
        let movieCd: String         // 영화 코드
        let movieNm: String         // 영화명
        let openDt: String          // 개봉일
        let salesAmt: String        // 매출액
        let salesShare: String      // 매출 점유율
        let salesInten: String      // 매출 증감
        let salesChange: String     // 매출 변화율
        let salesAcc: String        // 누적 매출액
        let audiCnt: String         // 당일 관객수
        let audiInten: String       // 관객수 증감
        let audiChange: String      // 관객수 변화율
        let audiAcc: String         // 누적 관객수
        let scrnCnt: String         // 상영 스크린 수
        let showCnt: String         // 상영 횟수
}
