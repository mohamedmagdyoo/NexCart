//
//  BrandDto.swift
//  NexCart
//
//  Created by shady ramadan on 29/06/2026.
//

import Foundation
struct BrandsResponseDTO: Codable {
    let smartCollections: [SmartCollectionDTO]

    enum CodingKeys: String, CodingKey {
        case smartCollections = "smart_collections"
    }
}

struct SmartCollectionDTO: Codable {
    let id: Int
    let title: String
    let image: SmartCollectionImageDTO?
}

struct SmartCollectionImageDTO: Codable {
    let src: String
}
