//
//  CartUseCase.swift
//  NexCart
//
//  Created by Antoneos Philip on 01/07/2026.
//

import Foundation
protocol CartUseCaseProtocol{
    func getAllCart() async throws -> [BagEntity]
    
    func getSingleProduct(productId:Int) async throws ->ProductEntity
    
    
}

final class CartUseCase:CartUseCaseProtocol{
  
    
    private let cartRepo : CartRepoProtcol
    
    init(cartRepo: CartRepoProtcol) {
        self.cartRepo = cartRepo
    }
    func getAllCart() async throws -> [BagEntity] {
      try await cartRepo.getAllProduct()
    }
    
    func getSingleProduct(productId:Int) async throws ->ProductEntity{
        try await cartRepo.getSingleProduct(productId : productId)
    }
    
}
