//
//  FavProductRepoInterface.swift
//  NexCart
//
//  Created by Mohamed Magdy on 02/07/2026.
//

import Foundation

protocol FavProductRepoInterface {
    func addFavorite(product: FavProduct) async throws
    func removeFavorite(productId: Int) async throws
    func getAllFavorites() throws -> [FavProduct]
    func isFav(productId: Int) -> Bool
    func syncFromRemote() async throws
}

