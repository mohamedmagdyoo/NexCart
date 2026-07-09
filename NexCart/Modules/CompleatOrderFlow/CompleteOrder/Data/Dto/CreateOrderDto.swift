//
//  CreateOrderDto.swift
//  NexCart
//
//  Created by Antoneos Philip on 06/07/2026.
//

import Foundation

struct CreateOrderRequestBody: Encodable {
    let order: OrderCreateBody
}

struct OrderCreateBody: Encodable {
    let currency: String
    let email: String
    let financialStatus: String
    let lineItems: [OrderLineItemBody]
    let shippingAddress: OrderShippingAddressBody
    let transactions: [OrderTransactionBody]
    let discountCodes: [OrderDiscountCodeBody]?

    enum CodingKeys: String, CodingKey {
        case currency, email, transactions
        case financialStatus = "financial_status"
        case lineItems = "line_items"
        case shippingAddress = "shipping_address"
        case discountCodes = "discount_codes"
    }
}

struct OrderLineItemBody: Encodable {
    let variantId: Int
    let quantity: Int

    enum CodingKeys: String, CodingKey {
        case variantId = "variant_id"
        case quantity
    }
}

struct OrderShippingAddressBody: Encodable {
    let firstName: String
    let lastName: String
    let address1: String
    let city: String
    let province: String
    let zip: String
    let country: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case address1
        case city, province, zip, country
    }
}

struct OrderTransactionBody: Encodable {
    let kind: String
    let status: String
    let gateway: String
    let amount: String
}

struct CreateOrderResponseDTO: Decodable {
    let order: CreatedOrderNode?
}

struct CreatedOrderNode: Decodable {
    let id: Int
    let name: String
    let email: String?
    let totalPrice: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email
        case totalPrice = "total_price"
    }
}
struct OrderDiscountCodeBody: Encodable {
    let code: String
    let amount: String
    let type: String   
}
