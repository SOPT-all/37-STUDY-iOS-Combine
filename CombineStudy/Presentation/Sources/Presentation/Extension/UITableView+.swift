//
//  UITableView+.swift
//  Baemin
//
//  Created by 김호성 on 2025.11.06.
//

import UIKit

extension UITableView {
    func register(_ cellClass: UITableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.typeIdentifier)
    }
}
