//
//  CartEndPoint.swift
//  NexCart
//
//  Created by Antoneos Philip on 01/07/2026.
//

import Foundation

enum CartEndPoint: EndPoint {

    case singleProduct(productId: Int)
    case deleteFromCart(draftOrderId: String)
    case allCart(customerId: Int)
    case updateQuantity(draftOrderId: String, lineItems: [DraftOrderLineItemUpdate])

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

        case .updateQuantity(let draftOrderId, _):
            return "/draft_orders/\(draftOrderId).json"
        }
    }

    var method: String {
        switch self {
        case .deleteFromCart:
            return "DELETE"
        case .updateQuantity:
            return "PUT"
        default:
            return "GET"
        }
    }

    var body: Data? {
        switch self {
        case .updateQuantity(_, let lineItems):
            let payload = DraftOrderUpdateBody(
                draftOrder: DraftOrderUpdatePayload(lineItems: lineItems)
            )
            return try? JSONEncoder().encode(payload)

        default:
            return nil
        }
    }
}
