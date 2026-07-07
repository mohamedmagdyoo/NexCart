//
//  CompleteOrderViewModel.swift
//  NexCart
//
//  Created by Antoneos Philip on 06/07/2026.
//

import Foundation

@MainActor
final class CompleteOrderViewModel: CompleteOrderViewModelProtocol {
    @Published var isLoading = false
    @Published var error: String?
    @Published var isOrderPlaced = false

    @Published var orderNumber: String?
    @Published var estimatedDelivery: String?

    private let completeOrderUseCase: CompleteOrderUseCaseProtocol
    private let applePayUseCase: ProcessPaymentWithApplePayUseCase
    let cartViewModel: CartViewModel

    init(
        completeOrderUseCase: CompleteOrderUseCaseProtocol,
        applePayUseCase: ProcessPaymentWithApplePayUseCase,
        cartViewModel: CartViewModel
    ) {
        self.completeOrderUseCase = completeOrderUseCase
        self.applePayUseCase = applePayUseCase
        self.cartViewModel = cartViewModel
    }

    var allItems: [BagItemEntity] {
        cartViewModel.cartData.flatMap { $0.items }
    }

    var images: [Int: String] {
        cartViewModel.images
    }

    func placeOrder(paymentMethod: PaymentMethodType, total: Double, address: AddressEntity) async {
        guard !allItems.isEmpty else {
            error = "Your cart is empty. Please add items before placing an order."
            return
        }

        isLoading = true
        error = nil

        if paymentMethod == .applePay {
            await processApplePayThenOrder(total: total, address: address)
        } else {
            await submitOrder(paymentMethod: paymentMethod, total: total, address: address)
        }
    }

    private func processApplePayThenOrder(total: Double, address: AddressEntity) async {
        do {
            _ = try await applePayUseCase.execute(total: total, currency: "USD", merchantIdentifier: "merchant.com.nexcart")
            await submitOrder(paymentMethod: .applePay, total: total, address: address)
        } catch {
            self.error = "Apple Pay failed: \(error.localizedDescription)"
            self.isLoading = false
        }
    }

    private func submitOrder(paymentMethod: PaymentMethodType, total: Double, address: AddressEntity) async {
        do {
            let result = try await completeOrderUseCase.execute(
                allItems: allItems,
                address: address,
                paymentMethod: paymentMethod,
                total: total
            )
            self.orderNumber = result.orderNumber

            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            let startDate = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
            let endDate = Calendar.current.date(byAdding: .day, value: 5, to: Date())!
            self.estimatedDelivery = "\(formatter.string(from: startDate)) — \(formatter.string(from: endDate))"

            isOrderPlaced = true
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
}
