//
//  MovieViewController.swift
//  Combine-Study
//
//  Created by 이상수 on 12/17/25.
//

import UIKit
import Combine

final class MovieViewController: UIViewController {

    private let movieView = MovieView()
    private let viewModel = MovieViewModel()
    private var cancellables = Set<AnyCancellable>()

    private var dataSource: [MovieAPI.DailyBoxOffice] = []

    override func loadView() {
        view = movieView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setTableView()
        bind()
        viewModel.load()
    }
    
    private func setTableView() {
        movieView.tableView.dataSource = self
        movieView.tableView.register(
            MovieCell.self,
            forCellReuseIdentifier: MovieCell.identifier
        )
    }

    private func bind() {
        viewModel.movies
            .sink { [weak self] movies in
                self?.dataSource = movies
                self?.movieView.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.isLoading
            .sink { [weak self] isLoading in
                self?.movieView.updateLoading(isLoading: isLoading)
            }
            .store(in: &cancellables)
    }
    
}

extension MovieViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieCell.identifier,
            for: indexPath
        ) as? MovieCell else {
            return UITableViewCell()
        }

        let movie = dataSource[indexPath.row]
        cell.configure(with: movie)
        return cell
    }
    
}
