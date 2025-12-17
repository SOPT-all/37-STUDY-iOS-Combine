//
//  HomeCollectionViewCell.swift
//  Movie_Combine_MVVM
//
//  Created by 이승준 on 12/17/25.
//

import UIKit

import Then
import SnapKit

final class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "HomeCollectionViewCell"
    
    let movieNMLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    let prdtYearLabel = UILabel().then {
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(movieNMLabel)
        self.addSubview(prdtYearLabel)
        
        movieNMLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(prdtYearLabel.snp.leading).offset(-10)
        }
        
        prdtYearLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(50)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: Movie, index: Int) {
        switch (index / 10 ) % 3 {
        case 0:
            movieNMLabel.textColor = .systemPink
        case 1:
            movieNMLabel.textColor = .systemCyan
        case 2:
            movieNMLabel.textColor = .systemGreen
        default:
            movieNMLabel.textColor = .white
        }
        movieNMLabel.text = String(index + 1) + ": " + data.movieNm
        prdtYearLabel.text = data.prdtYear
    }
    
}
