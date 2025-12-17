//
//  MovieView.swift
//  Combine-Study
//
//  Created by 이상수 on 12/17/25.
//

import UIKit
import SnapKit

final class MovieView: UIView {

    let tableView = UITableView()
    let loadingIndicator = UIActivityIndicatorView(style: .medium)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        addSubviews(
            tableView,
            loadingIndicator
        )
    }
    
    private func setLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
}

extension MovieView {
    
    func updateLoading(isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
    }
    
}
