//
//  MovieAPITableViewCell.swift
//  Combine-Study
//
//  Created by 김나연 on 12/16/25.
//

import UIKit
import SnapKit
import Then

class MovieAPITableViewCell: UITableViewCell {
    
    // MARK: - Property
    private let rankLabel = UILabel().then{
        $0.textColor = .white
        $0.font = .italicSystemFont(ofSize: 96)
    }
    
    private let nameLabel = UILabel().then{
        $0.textColor = .white
        $0.font = UIFont(name: "Pretendard-Thin", size: 40)
    }
    
    private let dateLabel = UILabel().then{
        $0.textColor = .white
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
    }
    
    private let todayAudienceLabel = UILabel().then{
        $0.textColor = .gray
        $0.font = UIFont(name: "Pretendard-Regular", size: 12)
    }
    
    private let allAudienceLabel = UILabel().then{
        $0.textColor = .gray
        $0.font = UIFont(name: "Pretendard-Regular", size: 12)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        [rankLabel, nameLabel, dateLabel, todayAudienceLabel, allAudienceLabel].forEach {
            contentView.addSubview($0)
        }
        
        rankLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.centerY.equalToSuperview()
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(rankLabel.snp.trailing).offset(10)
            $0.top.equalToSuperview().inset(25)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel.snp.leading)
            $0.bottom.equalToSuperview().inset(22)
        }
        
        todayAudienceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalTo(allAudienceLabel.snp.top).offset(-2)
        }
        
        allAudienceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(22)
        }
    }
}

extension MovieAPITableViewCell {
    func dataBind(_ data: MovieModel) {
        rankLabel.text = data.rank
        nameLabel.text = data.movieNm
        dateLabel.text = "개봉일: \(data.openDt)"
        todayAudienceLabel.text = "오늘 관객수: \(data.audiCnt)명"
        allAudienceLabel.text = "누적 관객수: \(data.audiAcc)명"
    }
}
