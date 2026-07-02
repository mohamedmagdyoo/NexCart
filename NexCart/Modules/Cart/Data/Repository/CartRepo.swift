//
//  CartRepo.swift
//  NexCart
//
//  Created by Antoneos Philip on 01/07/2026.
//

import Foundation

final class CartRepo:CartRepoProtcol {
   
     private let networkService:ApiServiceProtocol
    
    init(apiService:ApiServiceProtocol) {
        networkService=apiService
    }
    func getAllProduct() async throws -> [BagEntity] {
        let allCart: CartResponseDto = try await networkService.fetch(endPoint: CartEndPoint.allCart)
        return allCart.toEntities()
    }
   
    
}
