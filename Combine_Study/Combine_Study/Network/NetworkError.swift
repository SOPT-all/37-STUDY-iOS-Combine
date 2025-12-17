//
//  NetworkError.swift
//  Combine_Study
//
//  Created by 임소은 on 12/16/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingFailed
    case apiError(message: String)
    case unknown(Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "잘못된 URL입니다."
        case .invalidResponse: return "올바르지 않은 응답입니다."
        case .httpError(let code): return "HTTP 에러가 발생했습니다. (status: \(code))"
        case .decodingFailed: return "디코딩에 실패했습니다."
        case .apiError(let message): return message
        case .unknown(let error): return error.localizedDescription
        }
    }
}
