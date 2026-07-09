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

struct OutfitRequest {
    let selectedProducts: [SelectedProduct]
}

struct GeneratedOutfit: Equatable {
    let id: String
    let imageData: Data
    let generatedAt: Date
    var name: String?
}


extension ProductEntity {
    func toSelectedProduct() -> SelectedProduct {
        SelectedProduct(
            id: id,
            title: name,
            imageURL: imageURL,
            category: productType.isEmpty ? nil : productType,
            color: extractColor(),
            brand: brand
        )
    }

    private func extractColor() -> String? {
        guard let colorOptionIndex = options.firstIndex(where: {
            $0.name.lowercased() == "color" || $0.name.lowercased() == "colour"
        }) else {
            return nil
        }

        guard let firstVariant = variants.first else { return nil }

        switch colorOptionIndex {
        case 0: return firstVariant.option1
        case 1: return firstVariant.option2
        case 2: return firstVariant.option3
        default: return nil
        }
    }
}
