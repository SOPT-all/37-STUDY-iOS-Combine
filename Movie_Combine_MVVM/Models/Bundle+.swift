//
//  Bundle+.swift
//  Movie_Combine_MVVM
//
//  Created by 이승준 on 12/17/25.
//

import Foundation

extension Bundle {
    var movieAPIKey: String? {
        return infoDictionary?["MOVIE_API_KEY"] as? String
    }
}
