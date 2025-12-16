//
//  ViewController.swift
//  Movie_Combine_MVVM
//
//  Created by 이승준 on 12/13/25.
//

import UIKit
import Combine

import Then
import SnapKit

final class HomeView: UIView {

    let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(HomeCollectionViewCell.self,
                            forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collection.backgroundColor = .darkGray
        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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

final class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "HomeCollectionViewCell"
    
    let movieNMLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    let prdtYearLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(movieNMLabel)
        self.addSubview(prdtYearLabel)
        
        movieNMLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        prdtYearLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: Movie) {
        movieNMLabel.text = data.movieNm
        prdtYearLabel.text = data.prdtYear
    }
    
}

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private let viewModel = MovieViewModel()
    
    private var throttleWorkItem: DispatchWorkItem?
    
    private let inputSubject = PassthroughSubject<MovieViewModel.Input, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        homeView.collectionView.delegate = self
        homeView.collectionView.dataSource = self
        bineViewModel()
        inputSubject.send(.viewDidLoad)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        homeView.setCollectionViewLayout()
    }
    
    func bineViewModel() {
        let output = viewModel.transform(input: inputSubject.eraseToAnyPublisher())
        
        output
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] output in
                guard let self = self else { return }
                switch output {
                case .dataFetched:
                    self.homeView.collectionView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell
                        else {
                    return UICollectionViewCell()
                }
        let data = viewModel.movies[indexPath.row]
        cell.configure(data: data)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height
                
            if offsetY > contentHeight - height {
                throttleWorkItem?.cancel()
                
                throttleWorkItem = DispatchWorkItem { [weak self] in
                    guard let self = self else { return }
                    inputSubject.send(.hitBottom)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: throttleWorkItem!)
            }
    }
}

protocol InputOutputViewModelProtocol {
    associatedtype Input
    associatedtype Output

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}

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

    var movies: [Movie] = []
    private var isFetching: Bool = false

    private var currentPage: Int = 1
    private let size: Int = 10

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input
            .receive(on: DispatchQueue.global())
            .sink { [weak self] input in
                guard let self = self else { return }
                guard let apiKey = Bundle.main.movieAPIKey else { return }
                switch input {
                case .hitBottom, .viewDidLoad:
                    guard !isFetching else { return }
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
                            self.movies.append(contentsOf: response.movieListResult.movieList)
                            self.currentPage += 1
                            self.isFetching = false
                            self.output.send(.dataFetched)
                        })
                        .store(in: &cancellables)
                }
            }.store(in: &cancellables)
        return output.eraseToAnyPublisher()
    }
}

struct MovieListResponse: Codable {
    let movieListResult: MovieListResult
}

struct MovieListResult: Codable {
    let totCnt: Int
    let source: String
    let movieList: [Movie]
}

struct Movie: Codable {
    
    init(
        movieCd: String,
        movieNm: String,
        movieNmEn: String?,
        prdtYear: String,
        openDt: String,
        typeNm: String,
        prdtStatNm: String,
        nationAlt: String,
        genreAlt: String,
        repNationNm: String,
        repGenreNm: String,
        directors: [Director],
        companys: [Company]
    ) {
        self.movieCd = movieCd
        self.movieNm = movieNm
        self.movieNmEn = movieNmEn
        self.prdtYear = prdtYear
        self.openDt = openDt
        self.typeNm = typeNm
        self.prdtStatNm = prdtStatNm
        self.nationAlt = nationAlt
        self.genreAlt = genreAlt
        self.repNationNm = repNationNm
        self.repGenreNm = repGenreNm
        self.directors = directors
        self.companys = companys
    }
    
    let movieCd: String
    let movieNm: String
    let movieNmEn: String?
    let prdtYear: String
    let openDt: String
    let typeNm: String
    let prdtStatNm: String
    let nationAlt: String
    let genreAlt: String
    let repNationNm: String
    let repGenreNm: String
    let directors: [Director]
    let companys: [Company]
}

struct Director: Codable {
    let peopleNm: String
}

struct Company: Codable {
    let companyCd: String
    let companyNm: String
}

#Preview {
    HomeViewController()
}
