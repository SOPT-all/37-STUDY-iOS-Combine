//
//  MovieAPIViewController.swift
//  Combine-Study
//
//  Created by 김나연 on 12/16/25.
//

import UIKit
import SnapKit
import Then

class MovieAPIViewController: UIViewController {
    
    // MARK: - Property
    private let tableView = UITableView(frame: .zero, style: .plain)
    private var movies: [MovieModel] = []

    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.self.backgroundColor = .black
        tableView.do {
            $0.dataSource = self
            $0.delegate = self
            $0.register(MovieAPITableViewCell.self, forCellReuseIdentifier: MovieAPITableViewCell.identifier)
            $0.backgroundColor = .clear
        }
        setStyle()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.tintColor = .gray
    }
    
    // MARK: - SetStyle
    private func setStyle() {
        Task {
            do {
                let result = try await MovieService.shared.fetchMovieRankList()
                self.movies = result
                self.tableView.reloadData()
            } catch {
                print("데이터 바인딩 실패:", error)
            }
        }
    }
    
    // MARK: - SetLayout
    private func setLayout(){
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}
extension MovieAPIViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

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
