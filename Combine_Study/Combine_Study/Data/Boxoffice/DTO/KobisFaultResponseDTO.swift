//
//  KobisFaultResponseDTO.swift
//  Combine_Study
//
//  Created by 임소은 on 12/16/25.
//


import Foundation

struct KobisFaultResponseDTO: Decodable {
    let faultInfo: FaultInfo

    struct FaultInfo: Decodable {
        let errorCode: String?
        let message: String
    }
}
