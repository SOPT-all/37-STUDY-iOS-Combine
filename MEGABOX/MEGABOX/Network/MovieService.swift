//
//  MovieService.swift
//  MEGABOX
//
//  Created by 박정환 on 12/17/25.
//

import Foundation
import Moya

final class MovieService {
    let provider = MoyaProvider<MovieAPI>()
    
    func request(_ target: MovieAPI) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
