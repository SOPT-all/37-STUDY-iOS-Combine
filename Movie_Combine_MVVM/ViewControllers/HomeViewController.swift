//
//  ViewController.swift
//  Movie_Combine_MVVM
//
//  Created by 이승준 on 12/13/25.
//

import UIKit

import Then
import SnapKit

final class HomeView: UIView {
    
    let collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.register(HomeCollectionViewCell.self,
                            forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collection.backgroundColor = .darkGray
        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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

final class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "HomeCollectionViewCell"
    
    let movieNMLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
    }
    
    let prdtYearLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(movieNMLabel)
        self.addSubview(prdtYearLabel)
        
        movieNMLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        prdtYearLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: Movie) {
        movieNMLabel.text = data.movieNm
        prdtYearLabel.text = data.prdtYear
    }
    
}

class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        homeView.collectionView.delegate = self
        homeView.collectionView.dataSource = self
        view.backgroundColor = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        homeView.setCollectionViewLayout()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MovieMock.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell
                        else {
                    return UICollectionViewCell()
                }
        let data = MovieMock.data[indexPath.row]
        cell.configure(data: data)
        return cell
    }
}

struct MovieMock {
    
    static let data: [Movie] = [
        Movie(), Movie(), Movie(), Movie(), Movie(), Movie(), Movie(), Movie(), Movie(), Movie(),
        Movie(), Movie(), Movie(), Movie(), Movie(), Movie(), Movie(), Movie(), Movie(), Movie(),
        Movie(), Movie(), Movie(), Movie(), Movie(), Movie(), Movie(), Movie(), Movie(), Movie(),
        Movie(), Movie(), Movie(), Movie(), Movie(), Movie(), Movie(), Movie(), Movie(), Movie(),
    ]
    
}

struct Movie {
    
    let movieNm: String = "Hello"
    let prdtYear: String = "2023-03-01"
    
}

#Preview {
    HomeViewController()
}
