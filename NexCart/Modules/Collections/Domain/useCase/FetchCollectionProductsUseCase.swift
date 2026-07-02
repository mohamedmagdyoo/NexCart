//
//  FetchCollectionProductsUseCase.swift
//  NexCart
//
//  Created by shady ramadan on 02/07/2026.
//

import Foundation
protocol FetchCollectionProductsUseCaseProtocol {
    func execute(collectionId: String) async throws -> [ProductEntity]
}
 
final class FetchCollectionProductsUseCase: FetchCollectionProductsUseCaseProtocol {
    private let repo: CollectionsRepoProtocol
 
    init(repo: CollectionsRepoProtocol) {
        self.repo = repo
    }
 
    func execute(collectionId: String) async throws -> [ProductEntity] {
        try await repo.fetchProducts(forCollectionId: collectionId)
    }
}
