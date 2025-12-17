//
//  MainViewController.swift
//  CombineStudy
//
//  Created by 김호성 on 2025.12.16.
//

import Domain

import Combine
import UIKit

public final class MainViewController: UIViewController {
    
    // MARK: - RootView
    private let rootView = MainView()
    
    // MARK: - ViewModel
    private let movieViewModel: MovieViewModel
    
    // MARK: - Property
    private var rankingTableViewDataSource: UITableViewDiffableDataSource<RankingTableViewSection, RankingTableViewItem>?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Basic
    public init(movieViewModel: MovieViewModel) {
        self.movieViewModel = movieViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        view = rootView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        rootView.calendarView.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        setupRankingTableView()
    }
    
    // MARK: - Bind
    private func bind() {
        movieViewModel.boxOfficeRanking.sink(receiveValue: { [weak self] boxOfficeEntity in
            Log.d(boxOfficeEntity)
            self?.rootView.loadingIndicatorView.stopAnimating()
            var snapshot = NSDiffableDataSourceSnapshot<RankingTableViewSection, RankingTableViewItem>()
            snapshot.appendSections([.main])
            snapshot.appendItems(boxOfficeEntity.ranking.map({ RankingTableViewItem.ranking($0) }), toSection: .main)
            self?.rankingTableViewDataSource?.apply(snapshot, animatingDifferences: true)
        })
        .store(in: &cancellables)
    }
}

extension MainViewController {
    private enum RankingTableViewSection: Int {
        case main
    }
    
    private enum RankingTableViewItem: Hashable, Sendable {
        case ranking(BoxOfficeEntity.MovieEntity)
    }
    
    private func setupRankingTableView() {
        rootView.rankingTableView.register(RankingTableViewCell.self)
        
        rankingTableViewDataSource = UITableViewDiffableDataSource<RankingTableViewSection, RankingTableViewItem>(tableView: rootView.rankingTableView, cellProvider: { tableView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .ranking(let movieEntity):
                let cell = tableView.dequeueReusableCell(withIdentifier: RankingTableViewCell.typeIdentifier, for: indexPath)
                if let rankingTableViewCell = cell as? RankingTableViewCell {
                    rankingTableViewCell.configure(ranking: indexPath.row+1, movieEntity: movieEntity)
                }
                return cell
            }
        })
        rootView.rankingTableView.dataSource = rankingTableViewDataSource
    }
}

extension MainViewController: UICalendarSelectionSingleDateDelegate {
    public func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let dateComponents else { return }
        movieViewModel.fetchBoxOfficeRanking(date: dateComponents)
        rootView.loadingIndicatorView.startAnimating()
    }
}
