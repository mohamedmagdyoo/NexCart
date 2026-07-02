//
//  ProductsRepo.swift
//  NexCart
//
//  Created by Mohamed Magdy on 30/06/2026.
//

import Foundation


final class ProductsRepo: ProductsRepoProtocol {

    private let favProductReopo: FavProductRepoInterface

    init(favProductReopo: FavProductRepoInterface) {
        self.favProductReopo = favProductReopo
    }

    func fetchFavProducts() throws -> [FavProduct] {
        try favProductReopo.getAllFavorites()
    }

    func addFavProduct(product: FavProduct) async throws {
        try await favProductReopo.addFavorite(product: product)
    }

    func removeFavProduct(productId: Int) async throws {
        try await favProductReopo.removeFavorite(productId: productId)
    }

    func isFavProduct(productId: Int) -> Bool {
        favProductReopo.isFav(productId: productId)
    }

    func syncData() async throws {
        try await favProductReopo.syncFromRemote()
    }
}
