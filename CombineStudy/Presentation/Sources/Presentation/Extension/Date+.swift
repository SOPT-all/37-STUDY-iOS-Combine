//
//  File.swift
//  Presentation
//
//  Created by 김호성 on 2025.12.17.
//

import Foundation

extension Date {
    func string(withFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
