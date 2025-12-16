//
//  Combine_StudyApp.swift
//  Combine-Study
//
//  Created by 이나연 on 12/16/25.
//

import SwiftUI

@main
struct Combine_StudyApp: App {
    @StateObject private var viewModel = DailyBoxOfficeViewModel_Combine()
    
    var body: some Scene {
        WindowGroup {
            DailyBoxOfficeView(viewModel: viewModel)
        }
    }
}
