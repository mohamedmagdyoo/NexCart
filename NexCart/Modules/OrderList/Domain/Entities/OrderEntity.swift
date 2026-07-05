//
//  OrderEntity.swift
//  NexCart
//
//  Created by shady ramadan on 04/07/2026.
//

import Foundation

struct OrderLineItemEntity: Identifiable {
    let id: Int
    let title: String
    let price: Double
    let quantity: Int
    let imageURL: String
    let vendor: String
    let variantTitle: String
}

struct OrderEntity: Identifiable {
    let id: Int
    let orderNumber: Int
    let name: String
    let totalPrice: Double
    let financialStatus: String
    let fulfillmentStatus: String?
    let createdAt: String
    let lineItems: [OrderLineItemEntity]
    let currency: String
    
    var statusDisplay: String {
        switch financialStatus {
        case "paid":      return "Delivered"
        case "pending":   return "In Transit"
        case "refunded":  return "Refunded"
        default:          return financialStatus.capitalized
        }
    }
    
    var formattedDate: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        guard let date = formatter.date(from: createdAt) else { return createdAt }
        let display = DateFormatter()
        display.dateFormat = "MMM dd, yyyy"
        return display.string(from: date).uppercased()
    }
}
