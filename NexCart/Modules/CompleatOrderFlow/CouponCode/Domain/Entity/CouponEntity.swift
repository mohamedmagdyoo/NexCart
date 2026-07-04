//
//  CouponEntity.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import Foundation

// CouponEntity.swift
struct CouponEntity {
    let code: String
    let isActive: Bool
    let discountType: CouponDiscountType
    let value: Double // percentage (0-100) or fixed amount, depending on discountType
    let currencyCode: String?
    let startsAt: Date?
    let endsAt: Date?
}

enum CouponDiscountType {
    case percentage
    case fixedAmount
}

// Result After Applay the coupon
struct CouponApplicationResult {
    let originalTotal: Double
    let finalTotal: Double
    let isValid: Bool
    let discountAmount: Double
    let message: String
    let coupon: CouponEntity?
}
