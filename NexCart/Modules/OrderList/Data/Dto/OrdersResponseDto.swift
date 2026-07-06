//
//  OrdersResponseDto.swift
//  NexCart
//
//  Created by shady ramadan on 04/07/2026.
//

import Foundation
struct OrdersResponseDTO: Codable {
    let orders: [OrderDTO]
}

struct OrderDTO: Codable {
    let id: Int
    let orderNumber: Int
    let name: String
    let totalPrice: String
    let financialStatus: String
    let fulfillmentStatus: String?
    let createdAt: String
    let lineItems: [LineItemDTO]
    let currency: String
    
    enum CodingKeys: String, CodingKey {
        case currency
        case id
        case orderNumber     = "order_number"
        case name
        case totalPrice      = "total_price"
        case financialStatus = "financial_status"
        case fulfillmentStatus = "fulfillment_status"
        case createdAt       = "created_at"
        case lineItems       = "line_items"
    }
    
    func toEntity() -> OrderEntity {
        OrderEntity(
            id:                id,
            orderNumber:       orderNumber,
            name:              name,
            totalPrice:        Double(totalPrice) ?? 0,
            financialStatus:   financialStatus,
            fulfillmentStatus: fulfillmentStatus,
            createdAt:         createdAt,
            lineItems:         lineItems.map { $0.toEntity() },
            currency:           currency
        )
    }
}

struct LineItemDTO: Codable {
    let id: Int
    let title: String
    let price: String
    let quantity: Int
    let vendor: String
    let variantTitle: String?
    let productId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, quantity, vendor
        case variantTitle = "variant_title"
        case productId    = "product_id"
    }
    
    func toEntity() -> OrderLineItemEntity {
        OrderLineItemEntity(
            id:           id,
            title:        title,
            price:        Double(price) ?? 0,
            quantity:     quantity,
            imageURL:     "",
            vendor:       vendor,
            variantTitle: variantTitle ?? ""
        )
    }
}
