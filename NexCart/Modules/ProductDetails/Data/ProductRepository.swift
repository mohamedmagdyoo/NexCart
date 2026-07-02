//
//  ProductRepository.swift
//  NexCart
//
//  Created by shady ramadan on 01/07/2026.
//

import Foundation
final class ProductRepository: ProductRepositoryProtocol {
 
    private let apiService: ApiServiceProtocol
 
    init(apiService: ApiServiceProtocol = ApiService()) {
        self.apiService = apiService
    }
 
    func fetchProductDetails(productId: Int) async throws -> ProductDTO {
        let response: ProductResponseDTO = try await apiService.fetch(
                    endPoint: ProductEndPoint.productByID(productID: productId)
           )
        return response.product
    }
}

