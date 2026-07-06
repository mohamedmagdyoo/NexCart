//
//  CartEndPoint.swift
//  NexCart
//
//  Created by Antoneos Philip on 01/07/2026.
//

import Foundation
enum CartEndPoint: EndPoint {
    var body: Data?{
        nil
    }
    
    case singleProduct(productId:Int)
    case deleteFromCart(draftOrderId: String)
    case allCart(customerId: Int)

    var baseUrl: String {
        "https://mad46-ios-team9.myshopify.com/admin/api/2024-01"
    }

    var path: String {
        switch self {
        case .allCart(let customerId):
            return "/draft_orders.json?customer_id=\(customerId)&status=open&limit=250"

        case .singleProduct(let productId):
                    return "/products/\(productId).json"
                
        case .deleteFromCart(let draftOrderId):
            return "/draft_orders/\(draftOrderId).json"
        }
    }

    var method: String {
        switch self {
        case .deleteFromCart:
            return "DELETE"
        default:
            return "GET"
        }
    }
}
