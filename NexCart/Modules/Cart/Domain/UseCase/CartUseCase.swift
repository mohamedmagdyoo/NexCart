//
//  CartUseCase.swift
//  NexCart
//
//  Created by Antoneos Philip on 01/07/2026.
//


import Foundation

protocol CartUseCaseProtocol {
    func getAllCart(currentCustomerId: Int) async throws -> [BagEntity]
    func getSingleProduct(productId: Int) async throws -> ProductEntity
    func deleteFromCart(draftOrderId: String) async throws
    func updateQuantity(draftOrderId: String, lineItems: [DraftOrderLineItemUpdate]) async throws -> BagEntity
}



import Foundation

final class CartUseCase: CartUseCaseProtocol {

    private let repo: CartRepoProtcol

    init(repo: CartRepoProtcol) {
        self.repo = repo
    }

    func getAllCart(currentCustomerId: Int) async throws -> [BagEntity] {
        try await repo.getAllProduct(customerId: currentCustomerId)
    }

    func getSingleProduct(productId: Int) async throws -> ProductEntity {
        try await repo.getSingleProduct(productId: productId)
    }

    func deleteFromCart(draftOrderId: String) async throws {
        try await repo.deleteFromCart(draftOrderId: draftOrderId)
    }

    func updateQuantity(draftOrderId: String, lineItems: [DraftOrderLineItemUpdate]) async throws -> BagEntity {
        try await repo.updateQuantity(draftOrderId: draftOrderId, lineItems: lineItems)
    }
}
