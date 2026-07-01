//
//  ProductRepositoryProtocol.swift
//  NexCart
//
//  Created by shady ramadan on 01/07/2026.
//

import Foundation
protocol ProductRepositoryProtocol {
    func fetchProductDetails(productId: Int) async throws -> ProductDTO
}
