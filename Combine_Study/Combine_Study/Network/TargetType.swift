//
//  TargetType.swift
//  Combine_Study
//
//  Created by 임소은 on 12/16/25.
//

import Foundation

protocol TargetType {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var queryItems: [URLQueryItem] { get }
    var timeout: TimeInterval { get }
}

extension TargetType {
    var headers: [String: String] { ["Content-Type": "application/json"] }
    var timeout: TimeInterval { 15 }
    var queryItems: [URLQueryItem] { [] }
}
