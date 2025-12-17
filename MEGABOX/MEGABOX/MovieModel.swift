//
//  MovieModel.swift
//  MEGABOX
//
//  Created by 박정환 on 12/17/25.
//

import Foundation

struct MovieModel: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let poster: String
}
