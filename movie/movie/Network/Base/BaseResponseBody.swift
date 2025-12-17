//
//  BaseResponseBody.swift
//  movie
//
//  Created by sun on 12/17/25.
//

import Foundation

struct BaseResponseBody<T: ResponseModelType>: ResponseModelType {
    let code: Int
    let message: String
    let data: T
}
