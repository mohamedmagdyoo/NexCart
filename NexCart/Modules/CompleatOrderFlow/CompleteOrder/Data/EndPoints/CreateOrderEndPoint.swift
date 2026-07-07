//
//  CreateOrderEndPoint.swift
//  NexCart
//
//  Created by Antoneos Philip on 06/07/2026.
//

import Foundation

enum CreateOrderEndPoint: EndPoint {
    case createOrder(body: Data)

    var baseUrl: String {
        "https://mad46-ios-team9.myshopify.com/admin/api/2024-01"
    }

    var path: String { "/orders.json" }

    var method: String { "POST" }

    var body: Data? {
        switch self {
        case .createOrder(let data): return data
        }
    }
}
