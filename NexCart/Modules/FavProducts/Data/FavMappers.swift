//
//  FavMappers.swift
//  NexCart
//
//  Created by Mohamed Magdy on 02/07/2026.
//

import Foundation

extension ProductEntity{
    func mapToFavProduct() -> FavProduct{
        return FavProduct(id: id, brand: brand, name: name, price: price, imageURL: imageURL)
    }
}
