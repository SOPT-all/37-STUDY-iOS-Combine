//
//  DTO.swift
//  Data
//
//  Created by 김호성 on 2025.04.28.
//

import Domain

import Foundation

protocol DTO: Codable {
    associatedtype EntityType: Entity
    
    var entity: EntityType { get }
    
    init(entity: EntityType)
}
