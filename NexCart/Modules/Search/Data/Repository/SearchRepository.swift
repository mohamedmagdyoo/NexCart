//
//  SearchRepository.swift
//  NexCart
//
//  Created by shady ramadan on 03/07/2026.
//

import Foundation
 
final class SearchRepository: SearchRepoProtocol {
 
    private let apiService: ApiServiceProtocol
    private var cachedProducts: [ProductEntity] = []
 
    init(apiService: ApiServiceProtocol = ApiService()) {
        self.apiService = apiService
    }
 
    func fetchAllProducts() async throws -> [ProductEntity] {
        if !cachedProducts.isEmpty { return cachedProducts }
 
        let res: ProductsResponseDTO = try await apiService.fetch(
            endPoint: SearchEndPoint.allProducts
        )
        cachedProducts = res.products.map { $0.toEntity() }
        return cachedProducts
    }
}
