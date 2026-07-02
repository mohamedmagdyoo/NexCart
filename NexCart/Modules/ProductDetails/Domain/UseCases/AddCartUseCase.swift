//
//  AddCartUseCase.swift
//  NexCart
//
//  Created by Antoneos Philip on 29/06/2026.
//

import Foundation
class AddCartUseCase
{
    var productDetailsRepo:ProductDetailsRepo
    init(productDetailsRepo: ProductDetailsRepo) {
        self.productDetailsRepo = productDetailsRepo
    }
    func addToCart(
        variantID: Int,
        customerID: Int,
        quantity: Int
    ) async throws -> DraftOrder {
        try await productDetailsRepo.addToCart(
            variantID: variantID,
            customerID: customerID,
            quantity: quantity
        )
    }
    
    
}
