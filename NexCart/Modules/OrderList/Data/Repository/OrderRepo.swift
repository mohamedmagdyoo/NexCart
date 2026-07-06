//
//  OrderRepo.swift
//  NexCart
//
//  Created by shady ramadan on 04/07/2026.
//

import Foundation

final class OrderRepository: OrderRepoProtocol {
    private let remoteDataSource: OrderRemoteDataSourceProtocol
    
    init(remoteDataSource: OrderRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchOrders(customerId: Int) async throws -> [OrderEntity] {
        try await remoteDataSource.fetchOrders(customerId: customerId)
    }
}
