//
//  FetchFavProducts.swift
//  NexCart
//
//  Created by Mohamed Magdy on 30/06/2026.
//

import Foundation

protocol FetchFavProductsUseCaseProtocol {
    func execute() throws -> [FavProduct]
}

final class FetchFavProducts: FetchFavProductsUseCaseProtocol {
    private let repo: ProductsRepoProtocol

    init(repo: ProductsRepoProtocol) {
        self.repo = repo
    }

    func execute() throws -> [FavProduct] {
        try repo.fetchFavProducts()
    }
}
