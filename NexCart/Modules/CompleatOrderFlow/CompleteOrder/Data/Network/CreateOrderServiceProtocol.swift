//
//  CreateOrderServiceProtocol.swift
//  NexCart
//
//  Created by Antoneos Philip on 06/07/2026.
//

import Foundation

protocol CreateOrderServiceProtocol {
    func createOrder(orderBody: CreateOrderRequestBody) async throws -> CreateOrderResponseDTO
}
