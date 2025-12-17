//
//  MovieCell.swift
//  movie
//
//  Created by sun on 12/17/25.
//

import UIKit

final class MovieCell: UITableViewCell {
    static let reuseId = "MovieCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(_ movie: MovieInfo) {
        textLabel?.text = "\(movie.rank). \(movie.title)"
        detailTextLabel?.text = "누적 관객수: \(movie.audienceAccumulated)"
    }
}
