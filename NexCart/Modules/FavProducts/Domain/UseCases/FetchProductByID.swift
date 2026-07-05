//
//  FetchProductByIDUseCase.swift
//  NexCart
//
//  Created by shady ramadan on 03/07/2026.
//

import Foundation
protocol FetchProductByIDUseCaseProtocol{
    func execute (productID : Int) async throws -> ProductEntity
}

final class FetchProductByIdUseCase: FetchProductByIDUseCaseProtocol {
    private let repo: ProductsRepoProtocol
    
    init(repo: ProductsRepoProtocol) {
        self.repo = repo
    }
    
    func execute(productID productId: Int) async throws -> ProductEntity {
        try await repo.fetchProductById(productId: productId)
    }
}
