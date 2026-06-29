//
//  ProductBody.swift
//  NexCart
//
//  Created by Antoneos Philip on 29/06/2026.
//

import Foundation
struct DraftOrderRequest: Codable {
    let draftOrder: DraftOrderBody

    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

struct DraftOrderBody: Codable {
    let lineItems: [LineItem]
    let customerID: Int
    let useCustomerDefaultAddress: Bool

    enum CodingKeys: String, CodingKey {
        case lineItems = "line_items"
        case customerID = "customer_id"
        case useCustomerDefaultAddress = "use_customer_default_address"
    }
}

struct LineItem: Codable {
    let variantID: Int
    let quantity: Int

    enum CodingKeys: String, CodingKey {
        case variantID = "variant_id"
        case quantity
    }
}
