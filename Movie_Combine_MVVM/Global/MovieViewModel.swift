//
//  MovieViewModel.swift
//  Movie_Combine_MVVM
//
//  Created by 이승준 on 12/17/25.
//

import Foundation
import Combine

class MovieViewModel: InputOutputViewModelProtocol {

    enum Input {
        case hitBottom
        case viewDidLoad
    }

    enum Output {
        case dataFetched
    }

    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    var people: [People] = []
    var movies: [Movie] = []
    private var isFetching: Bool = false

    private var currentPage: Int = 1
    private let size: Int = 10

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .flatMap { input -> AnyPublisher<Input, Never> in
                switch input {
                case .hitBottom:
                    return Just(input)
                        .throttle(for: .seconds(0.3), scheduler: RunLoop.main, latest: true)
                        .eraseToAnyPublisher()
                default :
                    return Just(input).eraseToAnyPublisher()
                }
            }
            .sink { [weak self] input in
                guard let self = self else { return }
                switch input {
                case .hitBottom, .viewDidLoad:
                    fetchPeopleData()
                }
            }
            .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
    
    private func fetchPeopleData() {
        guard !isFetching else { return }
        guard let apiKey = Bundle.main.movieAPIKey else { return }
        isFetching = true
        URLSession.shared.dataTaskPublisher(for: URL(string: "https://www.kobis.or.kr/kobisopenapi/webservice/rest/people/searchPeopleList.json?key=\(apiKey)&curPage=\(currentPage)&itemPerPage=\(size)")!)
            .map(\.data)
            .decode(type: PeopleListResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("PeopleListResult failed: \(error)")
                case .finished:
                    break
                }
                self.isFetching = false
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                people.append(contentsOf: response.peopleListResult.peopleList)
                output.send(.dataFetched)
                currentPage += 1
                isFetching = false
            })
            .store(in: &cancellables)
    }

    private func fetchMovieData() {
        guard !isFetching else { return }
        guard let apiKey = Bundle.main.movieAPIKey else { return }
        isFetching = true
        URLSession.shared.dataTaskPublisher(for: URL(string: "https://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieList.json?key=\(apiKey)&curPage=\(currentPage)&itemPerPage=\(size)")!)
            .map(\.data)
            .decode(type: MovieListResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("MovieListResponse failed: \(error)")
                case .finished:
                    break
                }
                self.isFetching = false
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                movies.append(contentsOf: response.movieListResult.movieList)
                output.send(.dataFetched)
                currentPage += 1
                isFetching = false
            })
            .store(in: &cancellables)
    }
}
