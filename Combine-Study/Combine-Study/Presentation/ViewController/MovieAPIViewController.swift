//
//  MovieAPIViewController.swift
//  Combine-Study
//
//  Created by 김나연 on 12/16/25.
//

import UIKit

import Combine
import SnapKit
import Then

class MovieAPIViewController: UIViewController {
    
    // MARK: - Property
    
    private let movieView = MovieAPIView()
    private let viewModel = MoviewAPIViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private var movies: [MovieModel] = []

    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    
    
    // MARK: - LifeCycle
    
    override func loadView() {
        view = movieView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.self.backgroundColor = .black
        setDelegate()
        setBind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewWillAppearSubject.send(())
    }
    
    
    // MARK: - Set Delegate
    
    private func setDelegate() {
        movieView.tableView.delegate = self
        movieView.tableView.dataSource = self
    }
    
    
    // MARK: - Set Bind
    
    private func setBind(){
        let input = MoviewAPIViewModel.Input (viewWillAppear: viewWillAppearSubject.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        
        output.movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] movies in
                self?.movies = movies
                self?.movieView.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        output.isLoading
            .receive(on: DispatchQueue.main)
            .sink { isLoading in
                if isLoading {
                    self.movieView.loadingIndicator.startAnimating()
                    self.movieView.tableView.alpha = 0.5
                } else {
                    self.movieView.loadingIndicator.stopAnimating()
                    self.movieView.tableView.alpha = 1
                }
            }
            .store(in: &cancellables)
        
        output.error
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.showErrorAlert(message: error)
            }
            .store(in: &cancellables)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}


// MARK: - TableView Delegate

extension MovieAPIViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}


// MARK: - TableView DataSource

extension MovieAPIViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieAPITableViewCell.identifier, for: indexPath) as? MovieAPITableViewCell else { return UITableViewCell() }
        cell.dataBind(movies[indexPath.row])
        return cell
    }
}
