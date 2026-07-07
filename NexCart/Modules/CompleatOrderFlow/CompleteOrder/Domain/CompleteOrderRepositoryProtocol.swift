//
//  CompleteOrderRepositoryProtocol.swift
//  NexCart
//
//  Created by Antoneos Philip on 06/07/2026.
//

import Foundation

protocol CompleteOrderRepositoryProtocol {
    func placeOrder(orderInput: OrderCreateBody) async throws -> CompleteOrderEntity
}
