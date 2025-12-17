//
//  MainView.swift
//  CombineStudy
//
//  Created by 김호성 on 2025.12.16.
//

import Domain

import UIKit

final class MainView: UIView {
    
    // MARK: - Component
    let calendarView = UICalendarView().configured({
        $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    let rankingTableView = UITableView().configured({
        $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    let loadingIndicatorView = UIActivityIndicatorView().configured({
        $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    // MARK: - Basic
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .systemBackground
        setupHierarchy()
        setupLayout()
    }
    
    private func setupHierarchy() {
        addSubviews(
            calendarView,
            rankingTableView,
            loadingIndicatorView
        )
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            calendarView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            
            rankingTableView.topAnchor.constraint(equalTo: calendarView.bottomAnchor),
            rankingTableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            rankingTableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            rankingTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            rankingTableView.heightAnchor.constraint(equalTo: calendarView.heightAnchor),
            
            loadingIndicatorView.centerXAnchor.constraint(equalTo: rankingTableView.centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: rankingTableView.centerYAnchor),
        ])
    }
}
