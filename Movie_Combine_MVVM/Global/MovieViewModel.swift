//
//  MovieViewModel.swift
//  Movie_Combine_MVVM
//
//  Created by 이승준 on 12/17/25.
//

import Foundation
import Combine

final class MovieViewModel: InputOutputViewModelProtocol {
    
    enum Input {
        case hitHomeViewBottom
        case hitSearchViewBottom(String)
        case viewDidLoad
        case search(String)
    }

    enum Output {
        case dataFetched
    }

    private let output: PassthroughSubject<Output, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    var people: [People] = []
    var movies: [Movie] = []
    private var isSearchFetching: Bool = false
    private var isPeopleFetching: Bool = false

    private var peopleCurrentPage: Int = 1
    private var searchCurrentPage: Int = 1
    private let size: Int = 10

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .sink { [weak self] input in
                guard let self = self else { return }
                switch input {
                case .hitHomeViewBottom, .viewDidLoad:
                    fetchPeopleData()
                case .hitSearchViewBottom(let keyword):
                    guard !keyword.isEmpty else { return }
                    searchMovieData(keyword: keyword)
                case .search(let keyword):
                    self.movies = []
                    self.searchCurrentPage = 1
                    searchMovieData(keyword: keyword)
                }
            }
            .store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }

    private func fetchPeopleData() {
        guard !isPeopleFetching else { return }
        guard let apiKey = Bundle.main.movieAPIKey else { return }
        isPeopleFetching = true
        URLSession.shared.dataTaskPublisher(for: URL(string: "https://www.kobis.or.kr/kobisopenapi/webservice/rest/people/searchPeopleList.json?key=\(apiKey)&curPage=\(peopleCurrentPage)&itemPerPage=\(size)")!)
            .map(\.data)
            .decode(type: PeopleListResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("PeopleListResponse failed: \(error)")
                case .finished:
                    break
                }
                self.isPeopleFetching = false
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                people.append(contentsOf: response.peopleListResult.peopleList)
                output.send(.dataFetched)
                peopleCurrentPage += 1
                isPeopleFetching = false
            })
            .store(in: &cancellables)
    }

    private func searchMovieData(keyword: String) {
        guard !isSearchFetching else { return }
        guard let apiKey = Bundle.main.movieAPIKey else { return }
        isSearchFetching = true
        URLSession.shared
            .dataTaskPublisher(
                for: URL(
                    string: "https://www.kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieList.json?key=\(apiKey)&curPage=\(searchCurrentPage)&itemPerPage=\(size)&movieNm=\(keyword)")!
            )
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
                self.isSearchFetching = false
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                print("result: \(response.movieListResult.movieList)")
                movies.append(contentsOf: response.movieListResult.movieList)
                output.send(.dataFetched)
                searchCurrentPage += 1
                isSearchFetching = false
            })
            .store(in: &cancellables)
    }
}

