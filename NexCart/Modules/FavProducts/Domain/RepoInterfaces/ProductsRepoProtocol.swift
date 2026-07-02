//
//  ProductsRepoProtocol.swift
//  NexCart
//
//  Created by Mohamed Magdy on 30/06/2026.
//

import Foundation

protocol ProductsRepoProtocol {
    func fetchFavProducts() throws -> [FavProduct]
    func addFavProduct(product: FavProduct) async throws
    func removeFavProduct(productId: Int) async throws
    func isFavProduct(productId: Int) -> Bool
    func syncData() async throws
}
