//
//  MovieCell.swift
//  Combine-Study
//
//  Created by 이상수 on 12/17/25.
//

import UIKit
import SnapKit

final class MovieCell: UITableViewCell {

    static let identifier = "MovieCell"

    private let rankLabel = UILabel()
    private let rankIntenLabel = UILabel()
    private let titleLabel = UILabel()
    private let openDateLabel = UILabel()
    private let audienceLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setUI() {
        selectionStyle = .none

        rankLabel.font = .boldSystemFont(ofSize: 16)
        rankLabel.textColor = .systemBlue

        rankIntenLabel.font = .boldSystemFont(ofSize: 15)
        
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.numberOfLines = 2

        openDateLabel.font = .systemFont(ofSize: 12)
        openDateLabel.textColor = .darkGray

        audienceLabel.font = .systemFont(ofSize: 12)
        audienceLabel.textColor = .gray
    }

    private func setLayout() {
        contentView.addSubviews(
            rankLabel,
            rankIntenLabel,
            titleLabel,
            openDateLabel,
            audienceLabel
        )

        rankLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
        }

        rankIntenLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalToSuperview().offset(16)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(rankLabel.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(rankLabel)
        }

        openDateLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
        }

        audienceLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.top.equalTo(openDateLabel.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().inset(16)
        }
    }

}

extension MovieCell {
    
    func configure(with movie: MovieAPI.DailyBoxOffice) {
        rankLabel.text = movie.rank
        rankIntenLabel.text = "\(movie.rankInten)위 변동"
        titleLabel.text = movie.movieNm
        openDateLabel.text = "개봉일: \(movie.openDt)"
        audienceLabel.text = "누적 관객 수: \(movie.audiAcc)"
    }
    
}
