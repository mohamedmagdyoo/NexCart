//
//  CouponError.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import Foundation


enum CouponError: Error {
    case couponNotFound
    case couponExpired
    case couponNotYetActive
    case couponInactive
    case unsupportedDiscountType
    case network(Error)
}
