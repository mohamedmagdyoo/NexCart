//
//  AddCartResponseMapper.swift
//  NexCart
//
//  Created by Antoneos Philip on 29/06/2026.
//

import Foundation
struct DraftOrderMapper {

    static func map(from dto: DraftOrderResponse) -> DraftOrder {

        DraftOrder(
            id: dto.draftOrder.id,
            status: dto.draftOrder.status,
            totalPrice: dto.draftOrder.totalPrice,
            items: dto.draftOrder.lineItems.map {
                DraftOrderItem(
                    productID: $0.productID,
                    variantID: $0.variantID,
                    title: $0.title,
                    quantity: $0.quantity,
                    price: $0.price
                )
            }
        )
    }
}
