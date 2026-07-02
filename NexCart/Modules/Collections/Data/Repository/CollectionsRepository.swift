//
//  CollectionsRepository.swift
//  NexCart
//
//  Created by shady ramadan on 02/07/2026.
//

import Foundation
final class CollectionsRepository: CollectionsRepoProtocol {
 
    private let apiService: ApiServiceProtocol
 
    init(apiService: ApiServiceProtocol = ApiService()) {
        self.apiService = apiService
    }
 
    func fetchCollections() async throws -> [CustomCollectionEntity] {
        let res: CollectionsResponseDTO = try await apiService.fetch(
            endPoint: ProductEndPoint.customCollections
        )
        return res.customCollections.map { $0.toEntity() }
    }
 
    func fetchProducts(forCollectionId collectionId: String) async throws -> [ProductEntity] {
        if collectionId == "all" {
            let res: ProductsResponseDTO = try await apiService.fetch(
                endPoint: ProductEndPoint.allProducts
            )
            return res.products.map { $0.toEntity() }
        }
 
        let res: ProductsResponseDTO = try await apiService.fetch(
            endPoint: ProductEndPoint.productsByCollection(collectionId: collectionId)
        )
        return res.products.map { $0.toEntity() }
    }
}
