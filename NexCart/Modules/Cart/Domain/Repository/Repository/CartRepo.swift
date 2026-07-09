//
//  CartRepo.swift
//  NexCart
//
//  Created by Antoneos Philip on 01/07/2026.
//

import Foundation

final class CartRepo: CartRepoProtcol {

    private let networkService: ApiServiceProtocol

    init(apiService: ApiServiceProtocol) {
        networkService = apiService
    }

    func getAllProduct(customerId: Int) async throws -> [BagEntity] {
        print("🛒 Fetching cart for customer: \(customerId)")
        let allCart: CartResponseDto = try await networkService.fetch(
            endPoint: CartEndPoint.allCart(customerId: customerId)
        )
        print("🛒 Got \(allCart.draftOrders.count) draft orders")
        allCart.draftOrders.forEach {
            print("🛒 Draft order \($0.id) - customer: \($0.customer?.id ?? 0)")
        }
        return allCart.toEntities()
    }

    func getSingleProduct(productId: Int) async throws -> ProductEntity {
        let product: ProductResponseDTO = try await networkService.fetch(
            endPoint: CartEndPoint.singleProduct(productId: productId)
        )
        return product.product.toEntity()
    }

    func deleteFromCart(draftOrderId: String) async throws {
        let _: EmptyCartResponse = try await networkService.fetch(
            endPoint: CartEndPoint.deleteFromCart(draftOrderId: draftOrderId)
        )
    }

    func updateQuantity(draftOrderId: String, lineItems: [DraftOrderLineItemUpdate]) async throws -> BagEntity {
        let response: DraftOrderSingleResponseDto = try await networkService.fetch(
            endPoint: CartEndPoint.updateQuantity(draftOrderId: draftOrderId, lineItems: lineItems)
        )
        return response.draftOrder.toEntity()
    }
}
