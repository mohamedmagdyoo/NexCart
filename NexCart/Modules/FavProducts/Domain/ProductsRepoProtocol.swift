//
//  ProductsRepoProtocol.swift
//  NexCart
//
//  Created by Mohamed Magdy on 30/06/2026.
//

import Foundation

protocol ProductsRepoProtocol {
    func fetchFavProducts() throws -> [FavProduct]
    func removeFavProduct(productId: Int) throws
    func removeAllFav() throws
}
