//
//  HomeRepository.swift
//  NexCart
//
//  Created by shady ramadan on 28/06/2026.

import Foundation

final class HomeRepository: HomeRepoProtocol {

    private let apiService: ApiServiceProtocol

    init(apiService: ApiServiceProtocol = ApiService()) {
        self.apiService = apiService
    }

    func fetchAllProducts() async throws -> [ProductEntity] {
        let res: ProductsResponseDTO = try await apiService.fetch(endPoint: HomeEndPoint.allProducts)
        return res.products.map { $0.toEntity() }
    }

    func fetchProductsByBrand(_ brand: String) async throws -> [ProductEntity] {
        let res: ProductsResponseDTO = try await apiService.fetch(endPoint: HomeEndPoint.productsByBrand(brandName: brand))
        return res.products.map { $0.toEntity() }
    }

    func fetchProducts(limit: Int) async throws -> [ProductEntity] {
        let res: ProductsResponseDTO = try await apiService.fetch(endPoint: HomeEndPoint.products(limit: limit))
        return res.products.map { $0.toEntity() }
    }


    func fetchBrands() async throws -> [BrandEntity] {
        let res: BrandsResponseDTO = try await apiService.fetch(endPoint: HomeEndPoint.allBrands)
        return res.smartCollections.map { BrandEntity(id: "\($0.id)", name: $0.title, imageURL: $0.image?.src ?? "") }
    }

}
