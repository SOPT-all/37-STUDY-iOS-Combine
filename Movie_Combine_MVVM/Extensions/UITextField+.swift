//
//  UITextField+.swift
//  Movie_Combine_MVVM
//
//  Created by 이승준 on 12/17/25.
//

import UIKit
import Combine

extension UITextField {
    
    func textDidChangePublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .map { _ in self.text ?? "" }
            .eraseToAnyPublisher()
    }

}
