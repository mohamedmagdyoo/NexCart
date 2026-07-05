//
//  OrderEndPoint.swift
//  NexCart
//
//  Created by shady ramadan on 04/07/2026.
//

import Foundation

enum OrderEndPoint: EndPoint {
    case customerOrders(customerId: Int)
    case allOrders
    case productDetails(productId: Int)
    var body: Data? { nil }
    
    var baseUrl: String {
        "https://mad46-ios-team9.myshopify.com/admin/api/2024-01"
    }
    
    var path: String {
        switch self {
        case .customerOrders(let customerId):
            return "/orders.json?customer_id=\(customerId)&status=any"
        case .allOrders:
            return "/orders.json?status=any"
        case .productDetails(let productId):
            return "/products/\(productId).json"
        }
    }
    
    var method: String { "GET" }
}
