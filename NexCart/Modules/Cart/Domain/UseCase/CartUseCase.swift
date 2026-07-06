//
//  CartUseCase.swift
//  NexCart
//
//  Created by Antoneos Philip on 01/07/2026.
//

import Foundation
protocol CartUseCaseProtocol{
    func getAllCart(currentCustomerId : Int) async throws -> [BagEntity]
    
    func getSingleProduct(productId:Int) async throws ->ProductEntity
    
    func deleteFromCart(draftOrderId: String) async throws
}

final class CartUseCase:CartUseCaseProtocol{
  
    
    private let cartRepo : CartRepoProtcol
    
    init(cartRepo: CartRepoProtcol) {
        self.cartRepo = cartRepo
    }
    func getAllCart( currentCustomerId : Int) async throws -> [BagEntity] {
        try await cartRepo.getAllProduct(customerId: currentCustomerId)
    }
    
    func getSingleProduct(productId:Int) async throws ->ProductEntity{
        try await cartRepo.getSingleProduct(productId : productId)
    }
    
    func deleteFromCart(draftOrderId: String) async throws {
        try await cartRepo.deleteFromCart(draftOrderId: draftOrderId)
    }
    
}
