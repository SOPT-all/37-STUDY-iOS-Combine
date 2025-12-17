//
//  BoxOfficeMovie.swift
//  BoxOffice
//
//  Created by 안치욱 on 12/17/25.
//


import Foundation
import Combine

struct BoxOfficeMovie: Identifiable, Equatable {
    let id: String
    let rank: Int
    let name: String
    let openDate: String
    let audienceAcc: Int
}

protocol BoxOfficeRepositoryType {
    func fetchDaily(date: String) -> AnyPublisher<[BoxOfficeMovie], Error>
}

final class BoxOfficeRepository: BoxOfficeRepositoryType {
    private let client: NetworkClientType

    init(client: NetworkClientType) {
        self.client = client
    }

    func fetchDaily(date: String) -> AnyPublisher<[BoxOfficeMovie], Error> {
        let url = KOBISEndpoint.dailyBoxOffice(date: date).url

        return client.get(url, type: DailyBoxOfficeResponseDTO.self)
            .map { dto in
                dto.boxOfficeResult.dailyBoxOfficeList.map { item in
                    BoxOfficeMovie(
                        id: item.movieCd,
                        rank: Int(item.rank) ?? 0,
                        name: item.movieNm,
                        openDate: (item.openDt?.isEmpty == false ? item.openDt! : "-"),
                        audienceAcc: Int(item.audiAcc) ?? 0
                    )
                }
                .sorted { $0.rank < $1.rank }
            }
            .eraseToAnyPublisher()
    }
}
