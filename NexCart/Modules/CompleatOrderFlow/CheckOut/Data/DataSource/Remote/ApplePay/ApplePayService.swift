//
//  ApplePayService.swift
//  NexCart
//
//  Created by Mohamed Magdy on 04/07/2026.
//

import Foundation
import PassKit

protocol ApplePayServiceProtocol {
    func requestPayment(amount: Double, currencyCode: String, merchantIdentifier: String) async throws -> ApplePayToken
}


final class ApplePayService: NSObject, ApplePayServiceProtocol {
    private var continuation: CheckedContinuation<ApplePayToken, Error>?
    private let supportedNetworks: [PKPaymentNetwork] = [.visa, .masterCard, .amex]

    func requestPayment(amount: Double, currencyCode: String, merchantIdentifier: String) async throws -> ApplePayToken {
        
        guard PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks) else {
            throw ApplePayError.notAvailable
        }

        let request = PKPaymentRequest()
        request.merchantIdentifier = merchantIdentifier
        request.supportedNetworks = supportedNetworks
        request.merchantCapabilities = .capability3DS
        request.countryCode = "US"
        request.currencyCode = currencyCode
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "NexCart", amount: NSDecimalNumber(value: amount))
        ]

        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            let controller = PKPaymentAuthorizationController(paymentRequest: request)
            controller.delegate = self
            controller.present { presented in
                if !presented {
                    continuation.resume(throwing: ApplePayError.presentationFailed)
                    self.continuation = nil
                }
            }
        }
    }
}

extension ApplePayService: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationController(
        _ controller: PKPaymentAuthorizationController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        let token = ApplePayToken(
            paymentData: payment.token.paymentData,
            transactionIdentifier: payment.token.transactionIdentifier,
            network: payment.token.paymentMethod.network?.rawValue
        )
        continuation?.resume(returning: token)
        continuation = nil
        completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            if let continuation = self.continuation {
                continuation.resume(throwing: ApplePayError.cancelled)
                self.continuation = nil
            }
        }
    }
}
