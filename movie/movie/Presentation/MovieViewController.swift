//
//  MovieViewController.swift
//  movie
//
//  Created by sun on 12/17/25.
//

import UIKit
import Combine

import SnapKit
import Then

final class MovieViewController: UIViewController {

    // MARK: - Properties

    private let viewModel = MovieViewModel()
    private var cancellables = Set<AnyCancellable>()

    private let targetDateString = "20251216"
    private let displayDateString = "2025.12.16"

    // MARK: - UI Components

    private let headerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
    }

    private let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .secondaryLabel
    }

    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = .label
        $0.text = "어제 박스오피스 TOP 10"
    }

    private let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.tableFooterView = UIView()
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "박스오피스"
        view.backgroundColor = .systemBackground

        setupUI()
        bind()

        dateLabel.text = displayDateString
        viewModel.fetch(targetDate: targetDateString)
    }

    // MARK: - UI

    private func setupUI() {
        headerStackView.addArrangedSubview(dateLabel)
        headerStackView.addArrangedSubview(titleLabel)

        tableView.dataSource = self
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseId)

        view.addSubview(headerStackView)
        view.addSubview(tableView)

        headerStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(headerStackView.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    // MARK: - Bind

    private func bind() {
        viewModel.$movies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .compactMap { $0 }
            .sink { message in
                print("❌ 에러난다:", message)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITableViewDataSource

extension MovieViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieCell.reuseId,
            for: indexPath
        ) as! MovieCell
        cell.configure(viewModel.movies[indexPath.row])
        return cell
    }
}

