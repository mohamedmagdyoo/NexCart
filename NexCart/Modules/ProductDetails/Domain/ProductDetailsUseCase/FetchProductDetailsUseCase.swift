//
//  FetchProductDetailsUseCase.swift
//  NexCart
//
//  Created by shady ramadan on 01/07/2026.
//

import Foundation


protocol FetchProductDetailsUseCaseProtocol {
    func execute(productId: Int) async throws -> ProductDTO
}

final class FetchProductDetailsUseCase: FetchProductDetailsUseCaseProtocol {

    private let repository: ProductRepositoryProtocol

    init(repository: ProductRepositoryProtocol = ProductRepository()) {
        self.repository = repository
    }

    func execute(productId: Int) async throws -> ProductDTO {
        try await repository.fetchProductDetails(productId: productId)
    }
}
