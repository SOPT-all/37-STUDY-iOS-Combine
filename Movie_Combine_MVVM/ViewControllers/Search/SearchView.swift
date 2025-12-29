//
//  SearchView.swift
//  Movie_Combine_MVVM
//
//  Created by 이승준 on 12/17/25.
//

import UIKit
import Combine

import Then
import SnapKit

final class SearchView: UIView {
    
    let searchBar = UITextField().then {
        $0.isUserInteractionEnabled = true
        $0.placeholder = "검색어를 입력하세요"
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 2
        $0.layer.borderColor = UIColor.white.cgColor
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }

    let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(SearchMovieCollectionViewCell.self,
                            forCellWithReuseIdentifier: SearchMovieCollectionViewCell.identifier)
        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(searchBar)
        self.addSubview(collectionView)
        
        searchBar.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(100)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCollectionViewLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        let cellWidth: CGFloat = self.bounds.width
        flowLayout.itemSize = CGSize(width: cellWidth, height: 100)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        self.collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }
}

