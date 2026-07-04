//
//  ProductRemoteDataSource.swift
//  NexCart
//
//  Created by shady ramadan on 03/07/2026.
//

import Foundation
protocol ProductRemoteDataSourceProtocol{
    func fetchProductById(productId: Int) async throws -> ProductEntity}
class ProductRemoteDataSource : ProductRemoteDataSourceProtocol{
    private let apiService : ApiServiceProtocol
    init(apiService: ApiServiceProtocol = ApiService()) {
        self.apiService = apiService 
    }
    func fetchProductById(productId: Int) async throws -> ProductEntity {
        let response:ProductResponseDTO = try await apiService.fetch(
            endPoint: ProductEndPoint.productByID(productID: productId)
        )
        return response.product.toEntity()
    }
    
}
