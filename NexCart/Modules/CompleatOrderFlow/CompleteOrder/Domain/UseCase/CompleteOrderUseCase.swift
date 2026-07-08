//
//  CompleteOrderUseCase.swift
//  NexCart
//
//  Created by Antoneos Philip on 06/07/2026.
//

import Foundation

protocol CompleteOrderUseCaseProtocol {
    func execute(allItems: [BagItemEntity], address: AddressEntity, paymentMethod: PaymentMethodType, total: Double) async throws -> CompleteOrderEntity
}

final class CompleteOrderUseCase: CompleteOrderUseCaseProtocol {
    private let repository: CompleteOrderRepositoryProtocol

    init(repository: CompleteOrderRepositoryProtocol) {
        self.repository = repository
    }
    func execute(allItems: [BagItemEntity], address: AddressEntity, paymentMethod: PaymentMethodType, total: Double) async throws -> CompleteOrderEntity {
        let nameParts = address.fullName.components(separatedBy: " ")
        let firstName = nameParts.first ?? ""
        let lastName = nameParts.dropFirst().joined(separator: " ")

        let rate = AppSettings.shared.currencyRate
        let originalSubtotal = allItems.reduce(0.0) { $0 + ($1.price * rate * Double($1.quantity)) }
        let discountRatio = originalSubtotal > 0 ? (total / originalSubtotal) : 1.0

        let lineItems: [OrderLineItemBody] = allItems.compactMap { item in
            guard let variantId = item.variantId, variantId > 0 else {
                return nil
            }
            let discountedPrice = item.price * discountRatio
            return OrderLineItemBody(variantId: variantId, quantity: item.quantity, price: String(format: "%.2f", discountedPrice))
        }

        guard !lineItems.isEmpty else {
            throw NSError(domain: "CompleteOrderUseCaseError", code: 400, userInfo: [NSLocalizedDescriptionKey: "Items are missing variant IDs. Cannot place order."])
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
            amount: String(format: "%.2f", total / rate)
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

        return try await repository.placeOrder(orderInput: orderBody)
    }
}
