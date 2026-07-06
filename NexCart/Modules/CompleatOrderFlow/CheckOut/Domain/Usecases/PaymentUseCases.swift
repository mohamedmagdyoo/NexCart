//
//  PaymentUseCases.swift
//  NexCart
//
//  Created by Mohamed Magdy on 04/07/2026.
//

import Foundation

protocol ProcessPaymentWithApplePayUseCaseProtocol {
    func execute(total: Double, currency: String, merchantIdentifier: String) async throws -> PaymentResult
}
final class ProcessPaymentWithApplePayUseCase: ProcessPaymentWithApplePayUseCaseProtocol {
    private let paymentRepository: PaymentRepositoryProtocol
    init(paymentRepository: PaymentRepositoryProtocol) { self.paymentRepository = paymentRepository }
    func execute(total: Double, currency: String, merchantIdentifier: String) async throws -> PaymentResult {
        try await paymentRepository.payWithApplePay(total: total, currency: currency, merchantIdentifier: merchantIdentifier)
        
    }
}


protocol ProcessPaymentWithCashOnDeliveryUseCaseProtocol {
    func execute(total: Double) -> PaymentResult
}
final class ProcessPaymentWithCashOnDeliveryUseCase: ProcessPaymentWithCashOnDeliveryUseCaseProtocol {
    private let paymentRepository: PaymentRepositoryProtocol
    init(paymentRepository: PaymentRepositoryProtocol) { self.paymentRepository = paymentRepository }
    func execute(total: Double) -> PaymentResult {
        paymentRepository.payWithCashOnDelivery(total: total)
    }
}
