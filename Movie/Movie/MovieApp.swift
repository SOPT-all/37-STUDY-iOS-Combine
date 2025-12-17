//
//  MovieApp.swift
//  Movie
//
//  Created by 어재선 on 12/17/25.
//

import SwiftUI

@main
struct MovieApp: App {
    @StateObject private var pathModel = PathModel()
    var body: some Scene {
        WindowGroup {
            MovieListView()
                .environmentObject(pathModel)
        }
    }
}
