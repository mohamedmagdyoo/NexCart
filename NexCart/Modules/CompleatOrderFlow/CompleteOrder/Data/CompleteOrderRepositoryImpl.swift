//
//  CompleteOrderRepositoryImpl.swift
//  NexCart
//
//  Created by Antoneos Philip on 06/07/2026.
//

import Foundation

final class CompleteOrderRepositoryImpl: CompleteOrderRepositoryProtocol {
    private let service: CreateOrderServiceProtocol

    init(service: CreateOrderServiceProtocol) {
        self.service = service
    }

    func placeOrder(orderInput: OrderCreateBody) async throws -> CompleteOrderEntity {
        let requestBody = CreateOrderRequestBody(order: orderInput)
        let response = try await service.createOrder(orderBody: requestBody)

        guard let order = response.order else {
            throw NSError(
                domain: "CompleteOrderError",
                code: 400,
                userInfo: [NSLocalizedDescriptionKey: "Order not found in response"]
            )
        }

        return CompleteOrderEntity(
            id: order.id,
            orderNumber: order.name,
            email: order.email ?? "",
            totalPrice: order.totalPrice ?? "0.0"
        )
    }
}
