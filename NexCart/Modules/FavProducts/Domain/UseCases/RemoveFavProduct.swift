//
//  RemoveFavProduct.swift
//  NexCart
//
//  Created by Mohamed Magdy on 30/06/2026.
//

import Foundation

protocol RemoveFavProductUseCaseProtocol {
    func execute(productId: Int) async throws
}

final class RemoveFavProduct: RemoveFavProductUseCaseProtocol {
    private let repo: ProductsRepoProtocol

    init(repo: ProductsRepoProtocol) {
        self.repo = repo
    }

    func execute(productId: Int) async throws {
        try await repo.removeFavProduct(productId: productId)
    }
}
