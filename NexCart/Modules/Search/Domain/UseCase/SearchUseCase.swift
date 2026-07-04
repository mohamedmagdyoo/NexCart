//
//  SearchUseCase.swift
//  NexCart
//
//  Created by shady ramadan on 03/07/2026.
//

import Foundation
 
protocol SearchUseCaseProtocol {
    func execute(query: String) async throws -> [ProductEntity]
}
 
final class SearchUseCase: SearchUseCaseProtocol {
 
    private let repo: SearchRepoProtocol
 
    init(repo: SearchRepoProtocol = SearchRepository()) {
        self.repo = repo
    }
 
    func execute(query: String) async throws -> [ProductEntity] {
        let trimmed = query
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
 
        guard !trimmed.isEmpty else { return [] }
 
        let all = try await repo.fetchAllProducts()

        return all.filter { product in
            product.name.lowercased().contains(trimmed) ||
            product.brand.lowercased().contains(trimmed)
        }
    }
}
