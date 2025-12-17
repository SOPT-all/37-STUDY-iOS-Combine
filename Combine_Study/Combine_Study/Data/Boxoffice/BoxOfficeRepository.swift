//
//  BoxOfficeRepository.swift
//  Combine_Study
//
//  Created by 임소은 on 12/16/25.
//

import Foundation
import Combine

protocol BoxOfficeRepositoryProtocol {
    func fetchDailyBoxOffice(date: Date) -> AnyPublisher<[DailyBoxOfficeItem], NetworkError>
}

final class BoxOfficeRepository: BoxOfficeRepositoryProtocol {

    private let provider: NetworkProviding
    private let df = DateFormatter()

    init(provider: NetworkProviding = NetworkProvider()) {
        self.provider = provider
        df.locale = Locale(identifier: "ko_KR")
        df.dateFormat = "yyyyMMdd"
    }

    func fetchDailyBoxOffice(date: Date) -> AnyPublisher<[DailyBoxOfficeItem], NetworkError> {
        let targetDt = df.string(from: date)
        let target = KobisAPITarget.dailyBoxOffice(targetDt: targetDt)

        return provider.request(target)
            .map { (dto: DailyBoxOfficeResponseDTO) in
                dto.boxOfficeResult.dailyBoxOfficeList.map(DailyBoxOfficeItem.init(dto:))
            }
            .eraseToAnyPublisher()
    }
}
