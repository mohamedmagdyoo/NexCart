//
//  ProductBody.swift
//  NexCart
//
//  Created by Antoneos Philip on 29/06/2026.
//

import Foundation
struct DraftOrderRequest: Encodable {
    let draftOrder: DraftOrderBody

    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

struct DraftOrderBody: Encodable {
    let lineItems: [LineItem]
    let customer: CustomerRef
    let useCustomerDefaultAddress: Bool

    enum CodingKeys: String, CodingKey {
        case lineItems = "line_items"
        case customer
        case useCustomerDefaultAddress = "use_customer_default_address"
    }
}

struct CustomerRef: Encodable {
    let id: Int
}

struct LineItem: Encodable {
    let variantID: Int
    let quantity: Int

    enum CodingKeys: String, CodingKey {
        case variantID = "variant_id"
        case quantity
    }
}
