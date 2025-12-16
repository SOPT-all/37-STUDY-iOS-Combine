//
//  Untitled.swift
//  Combine-Study
//
//  Created by 이나연 on 12/16/25.
//

import Foundation

struct NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    func request<Response: Decodable>(
        endPoint: EndPoint,
        body: Encodable? = nil
    ) async throws -> Response {

        let url = makeRequestURL(endPoint: endPoint)
        var request = URLRequest(url: url)
        
        request.httpMethod = endPoint.requestType.key
        endPoint.header.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        if let body {
            let requestBody = try makeRequestBody(data: body)
            request.httpBody = requestBody
        }
        
        NetworkLogger.requestLog(request: request)
        
        return try await requestToResponse(request: request)
    }
}

extension NetworkService {
    private func makeRequestURL(endPoint: EndPoint) -> URL {
        let baseURL = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice" + endPoint.url
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            print(NetworkError.httpURLResponseError)
            return URL(string: "")!
        }
        
        if let queryParams = endPoint.queryParams {
            urlComponents.queryItems = queryParams.map{
                URLQueryItem(name: $0, value: $1)
            }
        }
        
        guard let url = urlComponents.url else {
            print(NetworkError.httpURLResponseError)
            return URL(string: "")!
        }
        
        return url
    }
    private func makeRequestBody<Body: Encodable>(data: Body) throws -> Data {
        do {
            let jsonEncoder = JSONEncoder()
            let requestBody = try jsonEncoder.encode(data)
            
            return requestBody
        } catch {
            throw NetworkError.requestEncodingError
        }
    }
    
    private func requestToResponse<Response: Decodable>(request: URLRequest) async throws -> Response {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.httpURLResponseError
        }
        
        NetworkLogger.responseLog(response: httpResponse, data: data)
        
        do {
            print("type\(Response.self)")
            let decoded = try JSONDecoder().decode(DailyBoxOfficeResponseDTO.self, from: data)
            
            return decoded as! Response
            
        } catch {
            throw NetworkError.responseDecodingError
        }
    }
}
