//
//  ProductDetailsRepo.swift
//  NexCart
//
//  Created by Antoneos Philip on 29/06/2026.
//

import Foundation
protocol ProductDetailsRepo{
        
    func addToCart(
        variantID: Int,
        customerID: Int,
        quantity: Int
    ) async throws -> DraftOrder
}
