//
//  CompleteOrderEntity.swift
//  NexCart
//
//  Created by Antoneos Philip on 06/07/2026.
//

import Foundation

struct CompleteOrderEntity {
    let id: Int
    let orderNumber: String
    let email: String
    let totalPrice: String
    
    var priceDisplay: String {
        "\(AppSettings.shared.selectedCurrency) \(String(format: "%.2f", totalPrice))"
    }
}
