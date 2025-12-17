//
//  File.swift
//  Domain
//
//  Created by 김호성 on 2025.12.16.
//

import Foundation

public struct BoxOfficeEntity: Entity {
    
    public struct MovieEntity: Codable, Sendable, Equatable, Hashable {
        public let name: String
        public let isNew: Bool
        public let rankVariance: Int
        public let audience: Int
        
        public init(name: String, isNew: Bool, rankVariance: Int, audience: Int) {
            self.name = name
            self.isNew = isNew
            self.rankVariance = rankVariance
            self.audience = audience
        }
    }
    
    public let ranking: [MovieEntity]
    
    public init(ranking: [MovieEntity]) {
        self.ranking = ranking
    }
}
