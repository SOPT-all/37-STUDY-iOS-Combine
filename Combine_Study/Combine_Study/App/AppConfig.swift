//
//  AppConfig.swift
//  Combine_Study
//
//  Created by 임소은 on 12/15/25.
//

import Foundation

enum AppConfig {
    static var kobisAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "KOBIS_API_KEY") as? String,
              !key.isEmpty,
              !key.contains("$(") else {
            fatalError("KOBIS_API_KEY 설정 누락: xcconfig/Info.plist 연결 확인")
        }
        return key
    }
}
