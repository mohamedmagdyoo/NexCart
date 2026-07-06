//
//  SelectedProduct.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

struct SelectedProduct: Equatable {
    let id: Int
    let title: String
    let imageURL: String
    let category: String?
    let color: String?
    let brand: String?
}

//MARK: For the request and the response in domain layer not data layer 
struct OutfitRequest {
    let selectedProducts: [SelectedProduct]
}

struct GeneratedOutfit: Equatable {
    let id: String
    let generatedImageURL: String
    let generatedAt: Date
}
