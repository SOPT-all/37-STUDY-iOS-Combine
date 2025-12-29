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
    
    let peopleNmLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    let roleNmLabel = UILabel().then {
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(peopleNmLabel)
        self.addSubview(roleNmLabel)
        
        peopleNmLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalTo(roleNmLabel.snp.leading).offset(-10)
        }
        
        roleNmLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(50)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: People, index: Int) {
        switch (index / 10 ) % 3 {
        case 0:
            peopleNmLabel.textColor = .systemPink
        case 1:
            peopleNmLabel.textColor = .systemCyan
        case 2:
            peopleNmLabel.textColor = .systemGreen
        default:
            peopleNmLabel.textColor = .white
        }
        peopleNmLabel.text = String(index + 1) + ": " + data.peopleNm
        roleNmLabel.text = data.repRoleNm
    }
    
}
