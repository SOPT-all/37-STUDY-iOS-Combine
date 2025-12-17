//
//  DailyBoxOfficeViewController.swift
//  HongJunBeom_Combine_Assignment
//
//  Created by 홍준범 on 12/16/25.
//

import UIKit
import Combine

import Then
import SnapKit

class DailyBoxOfficeViewController: UIViewController {
    
    private let contentView = DailyBoxOfficeView()
    private let viewModel = DailyBoxOfficeViewModel()
    
    private var boxOfficeList: [DailyBoxOffice] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let inquiryButtonTappedSubject = PassthroughSubject<Date, Never>()
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "일별 박스오피스"
        
        register()
        setDelegate()
        bind()
    }
    
    private func bind() {
        let input = DailyBoxOfficeViewModel.Input( inquiryButtonTapped: inquiryButtonTappedSubject.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        
        output.boxOfficeList
            .sink { [weak self] list in
                self?.boxOfficeList = list
                self?.contentView.movieTableView.reloadData()
            }
            .store(in: &cancellables)
        
        output.isLoading
            .sink { [weak self] isLoading in
                self?.contentView.setLoading(isLoading)
            }
            .store(in: &cancellables)
        
        contentView.onTapInquiry = { [weak self] date in
            self?.inquiryButtonTappedSubject.send(date)
        }
    }

    private func register() {
        contentView.movieTableView.register(DailyBoxOfficeTableViewCell.self, forCellReuseIdentifier: DailyBoxOfficeTableViewCell.identifier)
    }
    
    private func setDelegate() {
        contentView.movieTableView.dataSource = self
    }
}

extension DailyBoxOfficeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boxOfficeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyBoxOfficeTableViewCell.identifier, for: indexPath) as? DailyBoxOfficeTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: boxOfficeList[indexPath.row])
        return cell
    }
}
