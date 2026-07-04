//
//  ProductBodyMapper.swift
//  NexCart
//
//  Created by Antoneos Philip on 29/06/2026.
//

import Foundation
struct DraftOrderRequestMapper {

    static func map(
        variantID: Int,
        customerID: Int,
        quantity: Int
    ) -> DraftOrderRequest {

        DraftOrderRequest(
            draftOrder: DraftOrderBody(
                lineItems: [
                    LineItem(
                        variantID: variantID,
                        quantity: quantity
                    )
                ],
                customer: CustomerRef(id: customerID),
                useCustomerDefaultAddress: true
            )
        )
    }
}
