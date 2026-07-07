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
    let cartViewModel: CartViewModel

    init(completeOrderUseCase: CompleteOrderUseCaseProtocol, cartViewModel: CartViewModel) {
        self.completeOrderUseCase = completeOrderUseCase
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

    private var applePayUseCase: ProcessPaymentWithApplePayUseCase?

    private func processApplePayThenOrder(total: Double, address: AddressEntity) async {
        self.applePayUseCase = ProcessPaymentWithApplePayUseCase(
            paymentRepository: PaymentRepositoryImpl(applePayService: ApplePayService())
        )
            do {
                _ = try await applePayUseCase?.execute(total: total, currency: "USD", merchantIdentifier: "merchant.com.nexcart")
                await submitOrder(paymentMethod: .applePay, total: total, address: address)
            } catch {
                self.error = "Apple Pay failed: \(error.localizedDescription)"
                self.isLoading = false
            }
        
    }

    private func submitOrder(paymentMethod: PaymentMethodType, total: Double, address: AddressEntity) async {
        let nameParts = address.fullName.components(separatedBy: " ")
        let firstName = nameParts.first ?? ""
        let lastName = nameParts.dropFirst().joined(separator: " ")

        let lineItems: [OrderLineItemBody] = allItems.compactMap { item in
            guard let variantId = item.variantId, variantId > 0 else {
                print("⚠️ Skipping item with nil/zero variantId: \(item.title)")
                return nil
            }
            print("📦 Submitting order with \(item.quantity) quantity items")

            return OrderLineItemBody(variantId: variantId, quantity: item.quantity)
        }


        guard !lineItems.isEmpty else {
            error = "Items are missing variant IDs. Cannot place order."
            isLoading = false
            return
        }

        let shippingAddress = OrderShippingAddressBody(
            firstName: firstName,
            lastName: lastName.isEmpty ? firstName : lastName,
            address1: address.streetAddress,
            city: address.city,
            province: address.state.isEmpty ? "NA" : address.state,
            zip: address.zip.isEmpty ? "00000" : address.zip,
            country: "EG"
        )

        let transaction = OrderTransactionBody(
            kind: "sale",
            status: "success",
            gateway: paymentMethod == .cashOnDelivery ? "manual" : "apple_pay",
            amount: String(format: "%.2f", total)
        )

        let user = AppConstants.shared.getUserEntity()

        let orderBody = OrderCreateBody(
            currency: "USD",
            email: user?.email ?? "customer@example.com",
            financialStatus: paymentMethod == .cashOnDelivery ? "pending" : "paid",
            lineItems: lineItems,
            shippingAddress: shippingAddress,
            transactions: [transaction]
        )

            do {
                let result = try await completeOrderUseCase.execute(orderInput: orderBody)
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
