//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2025.12.16.
//

import Combine

public protocol MovieRepository {
    func fetchBoxOfficeRanking(date: String) -> AnyPublisher<BoxOfficeEntity, Error>
}
