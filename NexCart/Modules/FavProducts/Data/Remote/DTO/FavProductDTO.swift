//
//  FavProductDTO.swift
//  NexCart
//
//  Created by Mohamed Magdy on 02/07/2026.
//

import Foundation

struct FavoriteProductRemote: Codable {
    let productId: Int
    let addedAt: Date
    let brand: String
    let name: String
    let price: Double
    let imageURL: String
}
