//
//  CreateOrderService.swift
//  NexCart
//
//  Created by Antoneos Philip on 06/07/2026.
//

import Foundation

final class CreateOrderServiceImpl: CreateOrderServiceProtocol {
    private let apiService: ApiServiceProtocol

    init(apiService: ApiServiceProtocol) {
        self.apiService = apiService
    }

    func createOrder(orderBody: CreateOrderRequestBody) async throws -> CreateOrderResponseDTO {
        let encoded = try JSONEncoder().encode(orderBody)
        return try await apiService.fetch(endPoint: CreateOrderEndPoint.createOrder(body: encoded))
    }
}
