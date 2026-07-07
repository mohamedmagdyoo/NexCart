//
//  CompleteOrderUseCase.swift
//  NexCart
//
//  Created by Antoneos Philip on 06/07/2026.
//

import Foundation

protocol CompleteOrderUseCaseProtocol {
    func execute(orderInput: OrderCreateBody) async throws -> CompleteOrderEntity
}

final class CompleteOrderUseCase: CompleteOrderUseCaseProtocol {
    private let repository: CompleteOrderRepositoryProtocol

    init(repository: CompleteOrderRepositoryProtocol) {
        self.repository = repository
    }

    func execute(orderInput: OrderCreateBody) async throws -> CompleteOrderEntity {
        return try await repository.placeOrder(orderInput: orderInput)
    }
}
