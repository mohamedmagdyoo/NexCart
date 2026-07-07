//
//  CartRepoProtcol.swift
//  NexCart
//

import Foundation

protocol CartRepoProtcol {
    func getAllProduct(customerId: Int) async throws -> [BagEntity]
    func getSingleProduct(productId: Int) async throws -> ProductEntity
    func deleteFromCart(draftOrderId: String) async throws
    func updateQuantity(draftOrderId: String, lineItems: [DraftOrderLineItemUpdate]) async throws -> BagEntity
}
