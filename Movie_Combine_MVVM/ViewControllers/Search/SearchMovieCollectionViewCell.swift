//
//  SearchMovieCollectionViewCell.swift
//  Movie_Combine_MVVM
//
//  Created by 이승준 on 12/17/25.
//

import UIKit

import Then
import SnapKit

final class SearchMovieCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "SearchMovieCollectionViewCell"
    
    let movieNmLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    let yearLabel = UILabel().then {
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(movieNmLabel)
        self.addSubview(yearLabel)
        
        movieNmLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(yearLabel.snp.leading).offset(-10)
        }
        
        yearLabel.snp.makeConstraints { make in
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
            movieNmLabel.textColor = .systemPink
        case 1:
            movieNmLabel.textColor = .systemCyan
        case 2:
            movieNmLabel.textColor = .systemGreen
        default:
            movieNmLabel.textColor = .white
        }
        movieNmLabel.text = String(index + 1) + ": " + data.movieNm
        yearLabel.text = data.prdtYear
    }
    
}

