//
//  CheckOutEntities.swift
//  NexCart
//
//  Created by Mohamed Magdy on 04/07/2026.
//

import Foundation

enum PaymentMethodType: Hashable {
    case cashOnDelivery
    case applePay
}

struct PaymentMethod {
    let type: PaymentMethodType
    let displayName: String
}


struct PaymentResult {
    let method: PaymentMethodType
    let transactionId: String?      // nil for COD
    let paymentTokenData: Data?     // raw PassKit token, nil for COD — this is what your teammate needs to complete the order
    let network: String?            // card network, Apple Pay only
    let timestamp: Date
}
