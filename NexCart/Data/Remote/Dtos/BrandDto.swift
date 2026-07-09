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
extension SmartCollectionDTO {
    func toEntity() -> BrandEntity {
        BrandEntity(
            id: String(id),
            name: title,
            imageURL: image?.src ?? ""
        )
    }
}

struct CategoriesResponseDTO: Codable {
    let customCollections: [CustomCollectionDTO]

    enum CodingKeys: String, CodingKey {
        case customCollections = "custom_collections"
    }
}

struct CustomCollectionDTO: Codable {
    let id: Int
    let title: String
}

extension CustomCollectionDTO {
    func toEntity() -> CategoryEntity {
        CategoryEntity(id: String(id), name: title)
    }
}
