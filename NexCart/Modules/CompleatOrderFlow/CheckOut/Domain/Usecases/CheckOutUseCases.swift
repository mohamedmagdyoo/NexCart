//
//  CheckOutUseCases.swift
//  NexCart
//
//  Created by Mohamed Magdy on 04/07/2026.
//

//
//  CheckoutUseCases.swift
//  NexCart
//

import Foundation

// MARK: - Address
//Will use the GetAllAddressesUseCase


protocol SelectAddressUseCaseProtocol {
    func execute(ownerID: String, selected: AddressEntity) async throws -> [AddressEntity]
}

final class SelectAddressUseCase: SelectAddressUseCaseProtocol {
    private let addressRepository: AddressRepository

    init(addressRepository: AddressRepository) {
        self.addressRepository = addressRepository
    }

    func execute(ownerID: String, selected: AddressEntity) async throws -> [AddressEntity] {
        let allAddresses = try await addressRepository.getAllAddresses(ownerID: ownerID)
        let rest = allAddresses.filter { $0.id != selected.id }
        return [selected] + rest
    }
}

// MARK: - Payment method selection

protocol GetPaymentMethodsUseCaseProtocol {
    func execute() -> [PaymentMethod]
}
final class GetPaymentMethodsUseCase: GetPaymentMethodsUseCaseProtocol {
    func execute() -> [PaymentMethod] {
        [PaymentMethod(type: .cashOnDelivery, displayName: "Cash on Delivery"),
         PaymentMethod(type: .applePay, displayName: "Apple Pay")]
    }
}

protocol SelectPaymentMethodUseCaseProtocol {
    func execute(method: PaymentMethodType, from methods: [PaymentMethod]) -> PaymentMethod?
}
final class SelectPaymentMethodUseCase: SelectPaymentMethodUseCaseProtocol {
    func execute(method: PaymentMethodType, from methods: [PaymentMethod]) -> PaymentMethod? {
        methods.first { $0.type == method }
    }
}

