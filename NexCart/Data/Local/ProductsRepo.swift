//
//  ProductsRepo.swift
//  NexCart
//
//  Created by Mohamed Magdy on 30/06/2026.
//

import Foundation

final class ProductsRepo: ProductsRepoProtocol {
    private let dao: FavProductsDaoProtocol

    init(dao: FavProductsDaoProtocol = FavProductsDAO.shared) {
        self.dao = dao
    }

    func fetchFavProducts() throws -> [FavProduct] {
        try dao.getAllFav()
    }

    func removeFavProduct(productId: Int) throws {
        try dao.removeFromFav(productId: productId)
    }
}
