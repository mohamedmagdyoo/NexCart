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
    
    case allCart
    case singleProduct(productId:Int)
    case deleteFromCart(draftOrderId: String)

    var baseUrl: String {
        "https://mad46-ios-team9.myshopify.com/admin/api/2024-01"
    }

    var path: String {
        switch self {
        case .allCart:
            return "/draft_orders.json"

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
