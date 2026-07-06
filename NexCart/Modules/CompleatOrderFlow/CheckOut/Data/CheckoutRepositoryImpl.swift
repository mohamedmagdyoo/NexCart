//
//  CheckoutRepositoryImpl.swift
//  NexCart
//
//  Created by Mohamed Magdy on 04/07/2026.
//

import Foundation


final class PaymentRepositoryImpl: PaymentRepositoryProtocol {

    private let applePayService: ApplePayServiceProtocol
    

    init(applePayService: ApplePayServiceProtocol) {
        self.applePayService = applePayService
    }

    func payWithApplePay(total: Double, currency: String,merchantIdentifier: String) async throws -> PaymentResult {
        do {
            let token = try await applePayService.requestPayment(amount: total, currencyCode: currency, merchantIdentifier: merchantIdentifier)
            return PaymentResult(
                method: .applePay,
                transactionId: token.transactionIdentifier,
                paymentTokenData: token.paymentData,
                network: token.network,
                timestamp: Date()
            )
        } catch let error as ApplePayError {
            switch error {
            case .cancelled: throw PaymentError.cancelled
            case .notAvailable: throw PaymentError.notAvailable
            case .presentationFailed: throw PaymentError.presentationFailed
            }
        }
    }

    func payWithCashOnDelivery(total: Double) -> PaymentResult {
        PaymentResult(
            method: .cashOnDelivery,
            transactionId: nil,
            paymentTokenData: nil,
            network: nil,
            timestamp: Date()
        )
    }
}
