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


#Preview {
    SearchViewController()
}
