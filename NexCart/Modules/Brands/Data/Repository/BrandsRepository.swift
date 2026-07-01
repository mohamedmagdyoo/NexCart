//
//  BrandsRepository.swift
//  NexCart
//
//  Created by shady ramadan on 30/06/2026.
//

import Foundation

final class BrandsRepository: BrandsRepoProtocol {
    private let apiService: ApiServiceProtocol

    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
    }

    func fetchBrands() async throws -> [BrandEntity] {
        let response: BrandsResponseDTO = try await apiService.fetch(endPoint: BrandsEndPoint.allBrands)
        return response.smartCollections.map { $0.toEntity() }
    }

    func fetchProducts(forVendorName brandName: String) async throws -> [ProductEntity] {
        let response: ProductsResponseDTO = try await apiService.fetch(
            endPoint: BrandProductsEndPoint.productsByVendor(brandName: brandName)
        )
        let products = response.products.map { $0.toEntity() }

        let normalizedTarget = brandName.lowercased()
        return products.filter { $0.brand.lowercased() == normalizedTarget }
    }
}
