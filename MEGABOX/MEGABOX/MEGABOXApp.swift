//
//  MEGABOXApp.swift
//  MEGABOX
//
//  Created by 박정환 on 12/17/25.
//

import SwiftUI

@main
struct MEGABOXApp: App {
    @StateObject private var movieViewModel = MovieViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MovieView()
            }
            .environmentObject(movieViewModel) // ⭐ 여기!
        }
    }
}
