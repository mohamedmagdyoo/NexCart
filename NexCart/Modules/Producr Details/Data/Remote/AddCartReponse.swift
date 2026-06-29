//
//  AddCartReponse.swift
//  NexCart
//
//  Created by Antoneos Philip on 29/06/2026.
//

import Foundation
struct DraftOrder {
    let id: Int
    let status: String
    let totalPrice: String
    let items: [DraftOrderItem]
}

struct DraftOrderItem {
    let productID: Int
    let variantID: Int
    let title: String
    let quantity: Int
    let price: String
}
