//
//  OrderRepoProtocol.swift
//  NexCart
//
//  Created by shady ramadan on 04/07/2026.
//

import Foundation

protocol OrderRepoProtocol {
    func fetchOrders(customerId: Int) async throws -> [OrderEntity]
}
