//
//  FetchOrderUseCase.swift
//  NexCart
//
//  Created by shady ramadan on 04/07/2026.
//

import Foundation

protocol FetchOrdersUseCaseProtocol {
    func execute(customerId: Int) async throws -> [OrderEntity]
}

final class FetchOrdersUseCase: FetchOrdersUseCaseProtocol {
    private let repo: OrderRepoProtocol
    
    init(repo: OrderRepoProtocol) {
        self.repo = repo
    }
    
    func execute(customerId: Int) async throws -> [OrderEntity] {
        try await repo.fetchOrders(customerId: customerId)
    }
}
