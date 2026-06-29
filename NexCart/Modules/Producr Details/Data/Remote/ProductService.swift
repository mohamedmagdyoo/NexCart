//
//  ProductService.swift
//  NexCart
//
//  Created by Antoneos Philip on 29/06/2026.
//

import Foundation
final class ProductDetailsService
{
    init(networkClient: ApiServiceProtocol) {
        self.networkClient = networkClient
    }
    var networkClient:ApiServiceProtocol
    func addToCart(body: DraftOrderRequest) async throws -> DraftOrderResponse {
        try await networkClient.request(
            endPoint: ProductsEndPoints.addToCart,
            body: body
        )
    }
}
