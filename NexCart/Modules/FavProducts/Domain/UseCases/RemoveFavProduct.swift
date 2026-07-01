//
//  RemoveFavProduct.swift
//  NexCart
//
//  Created by Mohamed Magdy on 30/06/2026.
//

import Foundation

protocol RemoveFavProductUseCaseProtocol {
    func execute(productId: Int) throws
}

final class RemoveFavProduct: RemoveFavProductUseCaseProtocol {
    private let repo: ProductsRepoProtocol

    init(repo: ProductsRepoProtocol) {
        self.repo = repo
    }

    func execute(productId: Int) throws {
        try repo.removeFavProduct(productId: productId)
    }
}
