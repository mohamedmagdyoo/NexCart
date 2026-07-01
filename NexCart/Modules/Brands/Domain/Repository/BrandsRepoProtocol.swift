//
//  BrandsRepoProtocol.swift
//  NexCart
//
//  Created by shady ramadan on 30/06/2026.
//

import Foundation

protocol BrandsRepoProtocol {
    func fetchBrands() async throws -> [BrandEntity]
    func fetchProducts(forVendorName vendorName: String) async throws -> [ProductEntity]
}
