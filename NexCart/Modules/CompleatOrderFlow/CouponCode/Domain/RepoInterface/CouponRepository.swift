//
//  CouponRepository.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import Foundation


protocol CouponRepository {
    func fetchCoupon(code: String) async throws -> CouponEntity
}
