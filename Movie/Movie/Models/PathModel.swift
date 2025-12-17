//
//  PathModel.swift
//  Movie
//
//  Created by 어재선 on 12/17/25.
//

import Foundation
import Combine

class PathModel: ObservableObject {
    @Published var paths: [PathType] = []
    
    // 화면 추가 (push)
    func push(_ path: PathType) {
        paths.append(path)
    }
    
    // 뒤로가기 (pop)
    func pop() {
        if !paths.isEmpty {
            paths.removeLast()
        }
    }
    
    // 루트로 돌아가기
    func popToRoot() {
        paths.removeAll()
    }
}
