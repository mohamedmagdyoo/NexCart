//
//  CheckOutRepoInterface.swift
//  NexCart
//
//  Created by Mohamed Magdy on 04/07/2026.
//

import Foundation


protocol PaymentRepositoryProtocol {
    func payWithApplePay(total: Double, currency: String,merchantIdentifier: String) async throws -> PaymentResult
    func payWithCashOnDelivery(total: Double) -> PaymentResult
}
