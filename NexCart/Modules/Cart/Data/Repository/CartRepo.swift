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
    func getSingleProduct(productId: Int) async throws -> ProductEntity {
        let product : ProductResponseDTO = try await networkService.fetch(
            endPoint: CartEndPoint.singleProduct(productId: productId)
        )
        return product.product.toEntity()
    }
    
    func deleteFromCart(draftOrderId: String) async throws {
        let _: EmptyCartResponse = try await networkService.fetch(endPoint: CartEndPoint.deleteFromCart(draftOrderId: draftOrderId))
    }
    
}
