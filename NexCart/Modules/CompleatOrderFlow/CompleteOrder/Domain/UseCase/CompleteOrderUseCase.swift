//
//  CompleteOrderUseCase.swift
//  NexCart
//
//  Created by Antoneos Philip on 06/07/2026.
//

import Foundation

protocol CompleteOrderUseCaseProtocol {
    func execute(
        allItems: [BagItemEntity],
        address: AddressEntity,
        paymentMethod: PaymentMethodType,
        total: Double,
        discountCode: String?,
        discountAmount: Double
    ) async throws -> CompleteOrderEntity
}

final class CompleteOrderUseCase: CompleteOrderUseCaseProtocol {
    private let repository: CompleteOrderRepositoryProtocol

    init(repository: CompleteOrderRepositoryProtocol) {
        self.repository = repository
    }

    func execute(
        allItems: [BagItemEntity],
        address: AddressEntity,
        paymentMethod: PaymentMethodType,
        total: Double,
        discountCode: String?,
        discountAmount: Double
    ) async throws -> CompleteOrderEntity {
        let nameParts = address.fullName.components(separatedBy: " ")
        let firstName = nameParts.first ?? ""
        let lastName = nameParts.dropFirst().joined(separator: " ")

        let rate = AppSettings.shared.currencyRate

        let lineItems: [OrderLineItemBody] = allItems.compactMap { item in
            guard let variantId = item.variantId, variantId > 0 else {
                return nil
            }
            return OrderLineItemBody(variantId: variantId, quantity: item.quantity, price: String(format: "%.2f", item.price * rate))
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

        let discountCodes: [OrderDiscountCodeBody]? = {
            guard let discountCode, !discountCode.isEmpty, discountAmount > 0 else { return nil }
            return [
                OrderDiscountCodeBody(
                    code: discountCode,
                    amount: String(format: "%.2f", discountAmount),
                    type: "fixed_amount"
                )
            ]
        }()

        let orderBody = OrderCreateBody(
            currency: "\(AppSettings.shared.selectedCurrency)",
            email: user?.email ?? "customer@example.com",
            financialStatus: paymentMethod == .cashOnDelivery ? "pending" : "paid",
            lineItems: lineItems,
            shippingAddress: shippingAddress,
            transactions: [transaction],
            discountCodes: discountCodes
        )

        return try await repository.placeOrder(orderInput: orderBody)
    }
}
