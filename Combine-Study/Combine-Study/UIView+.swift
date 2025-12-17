//
//  UIView+.swift
//  Combine-Study
//
//  Created by 이상수 on 12/17/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
