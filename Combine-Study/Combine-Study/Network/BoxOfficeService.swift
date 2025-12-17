//
//  BoxOfficeService.swift
//  Combine-Study
//
//  Created by 이나연 on 12/16/25.
//

import Combine

protocol BoxOfficeService {
    func fetchDailyBoxOffice() async throws -> [DailyBoxOfficeModel]
}

struct DefaultBoxOfficeService: BoxOfficeService {
    let networkService =  NetworkService.shared
    
    func fetchDailyBoxOffice() async throws -> [DailyBoxOfficeModel] {
        do {
            let response: DailyBoxOfficeResponseDTO = try await networkService.request(endPoint: .dailyBoxOffice)
            
            return response.boxOfficeResult.dailyBoxOfficeList.map { $0.toEntity() }
            
        }
    }
}

protocol BoxOfficeService_Combine {
    func fetchDailyBoxOffice()-> AnyPublisher<[DailyBoxOfficeModel], Error>
}

struct CombineBoxOfficeService: BoxOfficeService_Combine {
    let networkService =  NetworkService.shared
    
    func fetchDailyBoxOffice() -> AnyPublisher<[DailyBoxOfficeModel], Error> {
        return Future { promise in
            Task {
                do {
                    let response: DailyBoxOfficeResponseDTO =
                    try await networkService.request(endPoint: .dailyBoxOffice)
                    
                    let result = response.boxOfficeResult.dailyBoxOfficeList
                        .map { $0.toEntity() }
                    
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
