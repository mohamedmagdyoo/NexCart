//
//  ProductsRepo.swift
//  NexCart
//
//  Created by Mohamed Magdy on 30/06/2026.
//

import Foundation


final class ProductsRepo: ProductsRepoProtocol {

    private let favProductReopo: FavProductRepoInterface
    private let ProductRemoteData : ProductRemoteDataSourceProtocol

    init(favProductReopo: FavProductRepoInterface,ProductRemoteData : ProductRemoteDataSourceProtocol) {
        self.favProductReopo = favProductReopo
        self.ProductRemoteData = ProductRemoteData
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

    func syncData(userId: String) async throws {
        print("Sync2")
        try await favProductReopo.syncFromRemote(userId: userId)
    }
    
    func cleanFavTabel() {
        favProductReopo.cleanFavTabel()
    }
    func fetchProductById(productId: Int) async throws -> ProductEntity {
        try await ProductRemoteData.fetchProductById(productId: productId)
      }
}
