//
//  UIView+.swift
//  Baemin
//
//  Created by 김호성 on 2025.11.12.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
