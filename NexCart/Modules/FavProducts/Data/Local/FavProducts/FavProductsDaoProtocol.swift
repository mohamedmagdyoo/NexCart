//
//  FavProductsDaoProtocol.swift
//  NexCart
//
//  Created by Mohamed Magdy on 30/06/2026.
//

import Foundation

// MARK: - Protocol
protocol FavProductsDaoProtocol {
    func addToFav(product: ProductEntity) throws
    func removeFromFav(productId: Int) throws
    func getAllFav() throws -> [FavProduct]
    func isFav(productId: Int) -> Bool
    func cleanFavTable() throws
}
