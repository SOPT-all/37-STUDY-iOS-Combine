//
//  APIHelper.swift
//  Combine-Study
//
//  Created by 이상수 on 12/17/25.
//

import UIKit

enum APIHelper {

    static func fetch<T: Decodable>(url: URL?) async throws -> T {
        guard let url else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }

}
