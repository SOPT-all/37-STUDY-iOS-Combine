//
//  ViewControllerFactory.swift
//  Presentation
//
//  Created by 김호성 on 2025.04.27.
//

import UIKit

public protocol ViewControllerFactory {
    func buildMainViewController() -> MainViewController
}
