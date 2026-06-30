//
//  BrandsRepoProtocol.swift
//  NexCart
//
//  Created by shady ramadan on 30/06/2026.
//

import Foundation

protocol BrandsRepoProtocol {
    func fetchBrands() async throws -> [BrandEntity]
    func fetchProducts(forCollectionId collectionId: String, brandName: String) async throws -> [ProductEntity]
    func fetchCategories() async throws -> [CategoryEntity]
}
