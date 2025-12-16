//
//  MovieAPIView.swift
//  Combine-Study
//
//  Created by 김나연 on 12/16/25.
//

import UIKit

import SnapKit
import Then

final class MovieAPIView: UIView {
    
    // MARK: - Property
    
    let tableView = UITableView(frame: .zero, style: .plain)
    
    let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - SetUI
    
    private func setUI() {
        tableView.do {
            $0.register(MovieAPITableViewCell.self, forCellReuseIdentifier: MovieAPITableViewCell.identifier)
            $0.backgroundColor = .clear
            $0.rowHeight = 120
        }
        
        loadingIndicator.do {
            $0.color = .white
            $0.hidesWhenStopped = true
        }
        
        backgroundColor = .black
        addSubviews(tableView, loadingIndicator)
    }
    
    
    // MARK: - SetLayout
    
    private func setLayout(){
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
