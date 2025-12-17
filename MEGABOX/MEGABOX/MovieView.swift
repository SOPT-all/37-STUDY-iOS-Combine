//
//  HomeView.swift
//  MEGABOX
//
//  Created by 박정환 on 12/17/25.
//

import SwiftUI
import Kingfisher

struct MovieView: View {
    @EnvironmentObject private var viewModel: MovieViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Image(.meboxTitle)
                    .padding(.leading, 12)
                    .padding(.top, 16)

                MovieChart
            }
        }
        .task {
            await viewModel.fetchNowPlaying()
        }
    }
    
    private var MovieChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(viewModel.movies) { movie in
                        VStack(alignment: .leading) {
                            if movie.poster == "poster3" {
                                Button {
                                } label: {
                                    ZStack {
                                        KFImage(URL(string: movie.poster))
                                            .resizable()
                                            .frame(width: 148, height: 212)
                                            .scaledToFit()
                                        ProgressView()
                                            .frame(width: 148, height: 212)
                                    }
                                }
                            } else {
                                ZStack {
                                    KFImage(URL(string: movie.poster))
                                        .resizable()
                                        .frame(width: 148, height: 212)
                                        .scaledToFit()
                                    ProgressView()
                                        .frame(width: 148, height: 212)
                                }
                            }
                            
                            Button(action: {}) {
                                Text("바로 예매")
                                    .font(.medium16)
                                    .foregroundColor(Color.purple03)
                                    .frame(width: 148, height: 36)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.purple03, lineWidth: 1)
                                    )
                            }
                            Text(movie.title)
                                .font(.bold22)
                                .frame(width: 148, alignment: .leading)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .padding(.bottom, 3)
                        }
                    }
                }
            }
        }
        .padding(.leading, 16)
    }
}


#Preview {
    NavigationStack {
        MovieView()
    }
    .environmentObject(MovieViewModel())
}
