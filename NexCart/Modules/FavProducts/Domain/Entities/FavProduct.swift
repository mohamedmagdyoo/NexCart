//
//  FavProduct.swift
//  NexCart
//
//  Created by Mohamed Magdy on 30/06/2026.
//

import Foundation

struct FavProduct: Identifiable, Equatable {
    let id: Int
    let brand: String
    let name: String
    let price: Double
    let imageURL: String
}
