//
//  DailyBoxOfficeTableViewCell.swift
//  HongJunBeom_Combine_Assignment
//
//  Created by 홍준범 on 12/17/25.
//

import UIKit

import SnapKit
import Then

class DailyBoxOfficeTableViewCell: UITableViewCell {
    
    static let identifier: String = "DailyBoxOfficeTableViewCell"
    
    private let rankLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = .black
    }
    
    private let movieTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .black
    }
    
    private let audienceLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .black
    }
    
    private let openDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .black
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .systemGray5
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        contentView.addSubview(rankLabel)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(audienceLabel)
        contentView.addSubview(openDateLabel)
        contentView.addSubview(separatorView)
    }
    
    private func setLayout() {
        rankLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(40)
        }
        
        movieTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(rankLabel.snp.trailing).offset(16)
            $0.top.equalToSuperview().offset(12)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        audienceLabel.snp.makeConstraints {
            $0.leading.equalTo(movieTitleLabel)
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(4)
        }
        
        openDateLabel.snp.makeConstraints {
            $0.leading.equalTo(audienceLabel.snp.trailing).offset(12)
            $0.centerY.equalTo(audienceLabel)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        separatorView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configure(with movie: DailyBoxOffice) {
        rankLabel.text = movie.rank
        movieTitleLabel.text = movie.movieNm
        
        let audienceCount = Int(movie.audiAcc) ?? 0
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        audienceLabel.text = "관객 \(formatter.string(from: NSNumber(value: audienceCount)) ?? "0")명"
        
        openDateLabel.text = "개봉일: \(movie.openDt)"
        
        // 순위에 따른 색상 변경
        switch movie.rank {
        case "1":
            rankLabel.textColor = .systemRed
        case "2":
            rankLabel.textColor = .systemOrange
        case "3":
            rankLabel.textColor = .systemYellow
        default:
            rankLabel.textColor = .systemGray
        }
    }
}
