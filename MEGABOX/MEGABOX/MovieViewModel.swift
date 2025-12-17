//
//  MovieViewModel.swift
//  MEGABOX
//
//  Created by 박정환 on 12/17/25.
//

import Foundation
import Moya
import Combine
import CombineMoya

final class MovieViewModel: ObservableObject {
    @Published var movies: [MovieModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    let service = MovieService()

    func fetchNowPlaying() {
        service.provider.requestPublisher(.nowPlaying(page: 1))
            .map(\.data)
            .decode(type: NowPlayingResponseDTO.self, decoder: JSONDecoder())
            .map { dto in
                dto.results.map {
                    MovieModel(
                        title: $0.title,
                        poster: "https://image.tmdb.org/t/p/w500" + ($0.posterPath ?? "")
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("현재 상영 중인 영화 불러오기 실패: \(error)")
                        self.movies = []
                    }
                },
                receiveValue: { [weak self] movies in
                    self?.movies = movies
                }
            )
            .store(in: &cancellables)
    }
}
