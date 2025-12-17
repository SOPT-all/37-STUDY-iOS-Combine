//
//  MovieListView.swift
//  Movie
//
//  Created by 어재선 on 12/17/25.
//

import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    @EnvironmentObject var pathModel: PathModel
    
    var body: some View {
        NavigationStack(path: $pathModel.paths) {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    errorView(error)
                } else {
                    movieList
                }
            }
            .navigationTitle("영화 목록")
            .navigationDestination(for: PathType.self) { pathType in
                switch pathType {
                case .detail(let movieCd):
                    MovieDetailView(movieCd: movieCd)
                }
                
            }
            
        }
        .onAppear {
            viewModel.fetchMovies()
        }
    }
    
    private var movieList: some View {
        List(viewModel.movies, id: \.movieCd) { movie in
            MovieRow(movie: movie)
                .onTapGesture {
                    pathModel.paths.append(.detail(movieCd: movie.movieCd))
                }
            
        }
        
    }
    
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Text("오류 발생")
                .font(.headline)
            Text(message)
                .foregroundStyle(.secondary)
            Button("다시 시도") {
                viewModel.fetchMovies()
            }
        }
    }
}

struct MovieRow: View {
    let movie: DailyBoxOffice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(movie.movieNm)
                .font(.headline)
            HStack {
                Text("누적관객: \(movie.audiAcc)")
                Text("·")
                Text("개봉일: \(movie.openDt)")
                
            }
            .font(.caption)
            .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}
