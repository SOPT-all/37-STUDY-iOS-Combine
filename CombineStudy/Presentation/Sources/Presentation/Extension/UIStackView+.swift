//
//  UIStackView+.swift
//  Baemin
//
//  Created by 김호성 on 2025.11.12.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            addArrangedSubview(view)
        }
    }
}
