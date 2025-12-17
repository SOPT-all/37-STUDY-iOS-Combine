//
//  SearchViewController.swift
//  Movie_Combine_MVVM
//
//  Created by 이승준 on 12/17/25.
//

import UIKit
import Combine

import Then
import SnapKit

final class SearchMovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "SearchMovieCollectionViewCell"
    
    let movieNmLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    let yearLabel = UILabel().then {
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(movieNmLabel)
        self.addSubview(yearLabel)
        
        movieNmLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(yearLabel.snp.leading).offset(-10)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(50)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: Movie, index: Int) {
        switch (index / 10 ) % 3 {
        case 0:
            movieNmLabel.textColor = .systemPink
        case 1:
            movieNmLabel.textColor = .systemCyan
        case 2:
            movieNmLabel.textColor = .systemGreen
        default:
            movieNmLabel.textColor = .white
        }
        movieNmLabel.text = String(index + 1) + ": " + data.movieNm
        yearLabel.text = data.prdtYear
    }
    
}

final class SearchView: UIView {
    
    let searchBar = UITextField().then {
        $0.isUserInteractionEnabled = true
        $0.placeholder = "검색어를 입력하세요"
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }

    let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(SearchMovieCollectionViewCell.self,
                            forCellWithReuseIdentifier: SearchMovieCollectionViewCell.identifier)
        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(searchBar)
        self.addSubview(collectionView)
        
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(100)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        let cellWidth: CGFloat = self.bounds.width
        flowLayout.itemSize = CGSize(width: cellWidth, height: 100)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        self.collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }
}

class SearchViewController: UIViewController {

    private let searchView = SearchView()
    private let viewModel = MovieViewModel()

    private var throttleWorkItem: DispatchWorkItem?

    private let inputSubject = PassthroughSubject<MovieViewModel.Input, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    private let scrollEventSubject = PassthroughSubject<Void, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = searchView
        searchView.collectionView.delegate = self
        searchView.collectionView.dataSource = self
        bindViewModel()
        hideKeyboardWhenTappedAround()
        inputSubject.send(.viewDidLoad)

        searchView.searchBar.textDidChangePublisher()
            .debounce(for: .seconds(0.3), scheduler: RunLoop.main)
            .sink { [weak self] keyword in
                guard let self else { return }
                self.inputSubject.send(.search(keyword))
                self.searchView.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        scrollEventSubject
            .throttle(for: .seconds(0.3), scheduler: RunLoop.main, latest: false)
            .sink { [weak self] _ in
                guard let self = self else { return }
                inputSubject.send(.hitSearchViewBottom(searchView.searchBar.text ?? ""))
            }
            .store(in: &cancellables)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.setCollectionViewLayout()
    }

    func bindViewModel() {
        let output = viewModel.transform(input: inputSubject.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] output in
                guard let self = self else { return }
                switch output {
                case .dataFetched:
                    self.searchView.collectionView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SearchMovieCollectionViewCell.identifier, for: indexPath) as? SearchMovieCollectionViewCell
                        else {
                    return UICollectionViewCell()
                }
        let data = viewModel.movies[indexPath.row]
        cell.configure(data: data, index: indexPath.row)
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100 {
            scrollEventSubject.send()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

class MovieViewModel: InputOutputViewModelProtocol {

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

#Preview {
    SearchViewController()
}
