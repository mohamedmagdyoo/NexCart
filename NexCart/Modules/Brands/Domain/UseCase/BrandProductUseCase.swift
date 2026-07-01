//
//  BrandProductUseCase.swift
//  NexCart
//
//  Created by shady ramadan on 30/06/2026.
//

import Foundation


protocol FetchBrandProductsUseCaseProtocol {
    func execute(vendorName: String) async throws -> [ProductEntity]
}

final class FetchBrandProductsUseCase: FetchBrandProductsUseCaseProtocol {
    private let repo: BrandsRepoProtocol

    init(repo: BrandsRepoProtocol) {
        self.repo = repo
    }

    func execute(vendorName: String) async throws -> [ProductEntity] {
        try await repo.fetchProducts(forVendorName: vendorName)
    }
}
