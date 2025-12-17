//
//  MovieDetailView.swift
//  Movie
//
//  Created by 어재선 on 12/17/25.
//

import SwiftUI

struct MovieDetailView: View {
    let movieCd: String
    @StateObject private var viewModel = MovieDetailViewModel()
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                errorView(error)
            } else if let movie = viewModel.movieInfo {
                contentView(movie)
            }
        }
        .navigationTitle("영화 상세")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchMovieDetail(movieCd: movieCd)
        }
    }
    
    private func contentView(_ movie: MovieInfo) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection(movie)
                Divider()
                infoSection(movie)
                Divider()
                castSection(movie)
                Divider()
                companySection(movie)
            }
            .padding()
        }
    }
    
    private func headerSection(_ movie: MovieInfo) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(movie.movieNm)
                .font(.title)
                .fontWeight(.bold)
            
            if !movie.movieNmEn.isEmpty {
                Text(movie.movieNmEn)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            HStack(spacing: 8) {
                if let audit = movie.audits.first {
                    TagView(text: audit.watchGradeNm, color: .blue)
                }
                TagView(text: movie.typeNm, color: .purple)
                if let genre = movie.genres.first {
                    TagView(text: genre.genreNm, color: .orange)
                }
            }
        }
    }
    
    private func infoSection(_ movie: MovieInfo) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle("영화 정보")
            
            InfoRow(title: "개봉일", value: formatDate(movie.openDt))
            InfoRow(title: "상영시간", value: "\(movie.showTm)분")
            InfoRow(title: "제작연도", value: movie.prdtYear)
            InfoRow(title: "제작상태", value: movie.prdtStatNm)
            InfoRow(title: "제작국가", value: movie.nations.map { $0.nationNm }.joined(separator: ", "))
            
            if !movie.showTypes.isEmpty {
                InfoRow(
                    title: "상영타입",
                    value: movie.showTypes.map { "\($0.showTypeGroupNm) \($0.showTypeNm)" }.joined(separator: ", ")
                )
            }
        }
    }
    
    private func castSection(_ movie: MovieInfo) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if !movie.directors.isEmpty {
                SectionTitle("감독")
                ForEach(movie.directors, id: \.peopleNm) { director in
                    PersonRow(name: director.peopleNm, nameEn: director.peopleNmEn)
                }
            }
            
            if !movie.actors.isEmpty {
                SectionTitle("출연")
                ForEach(movie.actors, id: \.peopleNm) { actor in
                    PersonRow(
                        name: actor.peopleNm,
                        nameEn: actor.peopleNmEn,
                        role: actor.cast.isEmpty ? nil : actor.cast
                    )
                }
            }
        }
    }
    
    private func companySection(_ movie: MovieInfo) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            if !movie.companys.isEmpty {
                SectionTitle("제작/배급")
                ForEach(movie.companys, id: \.companyCd) { company in
                    HStack {
                        Text(company.companyPartNm)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(width: 50, alignment: .leading)
                        Text(company.companyNm)
                            .font(.subheadline)
                    }
                }
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
                viewModel.fetchMovieDetail(movieCd: movieCd)
            }
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        guard dateString.count == 8 else { return dateString }
        let year = dateString.prefix(4)
        let month = dateString.dropFirst(4).prefix(2)
        let day = dateString.suffix(2)
        return "\(year).\(month).\(day)"
    }
}

// MARK: - Subviews

struct TagView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}

struct SectionTitle: View {
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.top, 4)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .font(.subheadline)
        }
    }
}

struct PersonRow: View {
    let name: String
    let nameEn: String
    var role: String? = nil
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline)
                if !nameEn.isEmpty {
                    Text(nameEn)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
            if let role {
                Text(role)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
