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
        bindViewModel()
        inputSubject.send(.viewDidLoad)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        homeView.setCollectionViewLayout()
    }
    
    func bindViewModel() {
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
        return viewModel.people.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell
                        else {
                    return UICollectionViewCell()
                }
        let data = viewModel.people[indexPath.row]
        cell.configure(data: data, index: indexPath.row)
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100 {
            inputSubject.send(.hitBottom)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}




#Preview {
    HomeViewController()
}
