//
//  AddCartResponse.swift
//  NexCart
//
//  Created by Antoneos Philip on 29/06/2026.
//

import Foundation
struct DraftOrderResponse: Decodable {
    let draftOrder: DraftOrderDTO

    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

struct DraftOrderDTO: Decodable {
    let id: Int
    let status: String
    let totalPrice: String
    let subtotalPrice: String
    let totalTax: String
    let lineItems: [DraftOrderLineItemDTO]

    enum CodingKeys: String, CodingKey {
        case id
        case status
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case totalTax = "total_tax"
        case lineItems = "line_items"
    }
}

struct DraftOrderLineItemDTO: Decodable {
    let id: Int
    let variantID: Int
    let productID: Int
    let title: String
    let quantity: Int
    let price: String

    enum CodingKeys: String, CodingKey {
        case id
        case variantID = "variant_id"
        case productID = "product_id"
        case title
        case quantity
        case price
    }
}
