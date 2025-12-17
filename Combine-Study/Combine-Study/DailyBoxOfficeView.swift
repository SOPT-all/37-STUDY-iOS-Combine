//
//  ContentView.swift
//  Combine-Study
//
//  Created by 이나연 on 12/16/25.
//

import SwiftUI

struct DailyBoxOfficeView: View {
    @StateObject var viewModel: DailyBoxOfficeViewModel_Combine
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Text("박스 오피스 영화 순위")
                .font(.headline)
            
            VStack(alignment: .leading) {
                ForEach(viewModel.dailyBoxOfficeList, id: \.movieCd) { item in
                    VStack(alignment: .leading) {
                        Text("\(item.rank)위")
                            .fontWeight(.bold)
                        Text(item.movieNm)
                            .foregroundStyle(.blue)
                        Text("\(item.openDt) 개봉")
                    }
                    Spacer()
                }
            }
        }.onAppear {
            self.viewModel.action(.viewDidLoad)
        }
        
    }
}
