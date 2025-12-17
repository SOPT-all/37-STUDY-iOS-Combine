//
//  Identifiable.swift
//  Presentation
//
//  Created by 김호성 on 2025.11.12.
//

import Foundation

protocol TypeIdentifiable {
    static var typeIdentifier: String { get }
}

extension TypeIdentifiable {
    static var typeIdentifier : String {
        return String(describing: self)
    }
}
