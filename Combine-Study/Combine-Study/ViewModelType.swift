//
//  ViewModelType.swift
//  Combine-Study
//
//  Created by 이나연 on 12/16/25.
//

import SwiftUI

protocol ViewModelType: ObservableObject {
    associatedtype Input
    
    func action(_ trigger: Input)
}
