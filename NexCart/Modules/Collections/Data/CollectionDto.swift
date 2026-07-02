//
//  CollectionDto.swift
//  NexCart
//
//  Created by shady ramadan on 02/07/2026.
//

import Foundation

struct CollectionsResponseDTO: Decodable {
    let customCollections: [CollectionDTO]
 
    enum CodingKeys: String, CodingKey {
        case customCollections = "custom_collections"
    }
}
 
struct CollectionDTO: Decodable {
    let id: Int
    let title: String
    let image: CollectionImageDTO?
}
 
struct CollectionImageDTO: Decodable {
    let src: String
}
 
extension CollectionDTO {
    func toEntity() -> CustomCollectionEntity {
        CustomCollectionEntity(
            id: String(id),
            title: title,
            imageURL: image?.src ?? ""
        )
    }
}
