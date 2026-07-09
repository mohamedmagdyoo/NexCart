//
//  ProductRepoImpl.swift
//  NexCart
//
//  Created by Antoneos Philip on 29/06/2026.
//

import Foundation
class ProductDetailRepoImpl:ProductDetailsRepo{
    var productDetailsService:ProductDetailsService
   
    init(productDetailsService: ProductDetailsService) {
        self.productDetailsService = productDetailsService
    }
    
    func addToCart(
        variantID: Int,
        customerID: Int,
        quantity: Int
    ) async throws -> DraftOrder {

        let request = DraftOrderRequestMapper.map(
            variantID: variantID,
            customerID: customerID,
            quantity: quantity
        )
        print("Request Body: \(request)")
        let response = try await productDetailsService.addToCart(body: request)

        return DraftOrderMapper.map(from: response)
    }
    
}
