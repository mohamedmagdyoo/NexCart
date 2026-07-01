//
//  BrandProductUseCase.swift
//  NexCart
//
//  Created by shady ramadan on 30/06/2026.
//

import Foundation


protocol FetchBrandProductsUseCaseProtocol {
    func execute(collectionId: String, brandName: String) async throws -> [ProductEntity]
    func fetchCategories() async throws -> [CategoryEntity]
}

final class FetchBrandProductsUseCase: FetchBrandProductsUseCaseProtocol {
    private let repo: BrandsRepoProtocol

    init(repo: BrandsRepoProtocol) {
        self.repo = repo
    }

    func execute(collectionId: String, brandName: String) async throws -> [ProductEntity] {
        try await repo.fetchProducts(forCollectionId: collectionId, brandName: brandName)
    }

    func fetchCategories() async throws -> [CategoryEntity] {
        try await repo.fetchCategories()
    }
}
