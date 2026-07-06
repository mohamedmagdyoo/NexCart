//
//  HuggingFaceDTOs.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

struct HuggingFaceRequestDTO: Encodable {
    let inputs: String
}

struct HuggingFaceErrorDTO: Decodable {
    let error: String?
    let estimatedTime: Double?

    enum CodingKeys: String, CodingKey {
        case error
        case estimatedTime = "estimated_time"
    }
}
