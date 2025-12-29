//
//  InputOutputViewModelProtocol.swift
//  Movie_Combine_MVVM
//
//  Created by 이승준 on 12/17/25.
//

import Combine

protocol InputOutputViewModelProtocol {
    associatedtype Input
    associatedtype Output

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}
