//
//  BaseService.swift
//  movie
//
//  Created by sun on 12/17/25.
//

import Foundation

class BaseService<Target: TargetType> {
    let provider = NetworkProvider<Target>()

    func request<T: ResponseModelType>(with target: Target) async throws -> BaseResponseBody<T> {
        
        let urlRequest = try provider.makeRequest(target)
        
        NetworkLogger.logRequest(urlRequest, target: target)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            NetworkLogger.logResponse(data: data, response: response, target: target)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.responseError
            }
            
            let statusCode = httpResponse.statusCode

            guard 200..<300 ~= statusCode else {
                if statusCode == 404 {
                    throw NetworkError.notFoundError
                } else if statusCode == 500 {
                    throw NetworkError.internalServerError
                } else {
                    throw NetworkError.responseError
                }
            }
            
            do {
                return try JSONDecoder().decode(BaseResponseBody<T>.self, from: data)
            } catch {
                throw NetworkError.responseDecodingError
            }
            
        } catch {
            NetworkLogger.logError(error)
            throw error
        }
    }
}

extension BaseService {

    func requestRaw<T: Decodable>(with target: Target) async throws -> T {
        let urlRequest = try provider.makeRequest(target)

        NetworkLogger.logRequest(urlRequest, target: target)

        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)

            NetworkLogger.logResponse(data: data, response: response, target: target)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.responseError
            }

            let statusCode = httpResponse.statusCode
            guard 200..<300 ~= statusCode else {
                if statusCode == 404 { throw NetworkError.notFoundError }
                if statusCode == 500 { throw NetworkError.internalServerError }
                throw NetworkError.responseError
            }

            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.responseDecodingError
            }

        } catch {
            NetworkLogger.logError(error)
            throw error
        }
    }
}
