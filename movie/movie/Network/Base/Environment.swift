//
//  Environment.swift
//  movie
//
//  Created by sun on 12/17/25.
//

import Foundation

enum Environment {
    static let baseURL: String =
        Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as! String

    static let kobisAPIKey: String =
        Bundle.main.object(forInfoDictionaryKey: "KOBIS_API_KEY") as! String
}
