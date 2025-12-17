//
//  RankingTableViewCell.swift
//  Presentation
//
//  Created by 김호성 on 2025.12.17.
//

import Domain

import UIKit

class RankingTableViewCell: UITableViewCell {
    
    // MARK: - Component
    let rankingStackView = UIStackView().configured({
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    let rankingLabel = UILabel().configured({
        $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    let newLabel = UILabel().configured({
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "NEW"
        $0.textColor = .systemRed
    })
    
    let rankVarianceStackView = UIStackView().configured({
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    let rankVarianceImageView = UIImageView().configured({
        $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    let rankVarianceLabel = UILabel().configured({
        $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    let infoStackView = UIStackView().configured({
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .leading
        $0.distribution = .equalSpacing
        $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    let nameLabel = UILabel().configured({
        $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    let audienceLabel = UILabel().configured({
        $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    // MARK: - Basic
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        contentView.addSubviews(
            rankingStackView,
            infoStackView,
        )
        rankingStackView.addArrangedSubviews(
            rankingLabel,
            newLabel,
            rankVarianceStackView,
        )
        rankVarianceStackView.addArrangedSubviews(
            rankVarianceImageView,
            rankVarianceLabel,
        )
        infoStackView.addArrangedSubviews(
            nameLabel,
            audienceLabel,
        )
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            rankingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rankingStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            infoStackView.leadingAnchor.constraint(equalTo: rankingStackView.trailingAnchor, constant: 16),
            infoStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    // MARK: - Configure
    func configure(ranking: Int, movieEntity: BoxOfficeEntity.MovieEntity) {
        rankingLabel.text = "\(ranking)"
        nameLabel.text = movieEntity.name
        newLabel.isHidden = !movieEntity.isNew
        rankVarianceLabel.isHidden = movieEntity.rankVariance == 0
        rankVarianceLabel.text = "\(abs(movieEntity.rankVariance))"
        if movieEntity.rankVariance > 0 {
            rankVarianceImageView.image = UIImage(systemName: "arrowtriangle.up.fill")
            rankVarianceImageView.tintColor = .systemRed
        } else if movieEntity.rankVariance < 0 {
            rankVarianceImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
            rankVarianceImageView.tintColor = .systemBlue
        } else {
            rankVarianceImageView.image = nil
        }
        audienceLabel.text = "\(movieEntity.audience)명"
    }
}
