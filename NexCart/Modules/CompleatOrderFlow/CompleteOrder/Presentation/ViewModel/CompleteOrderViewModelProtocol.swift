//
//  CompleteOrderViewModelProtocol.swift
//  NexCart
//
//  Created by Antoneos Philip on 06/07/2026.
//

import Foundation

protocol CompleteOrderViewModelProtocol: ObservableObject {
    var isLoading: Bool { get set }
    var error: String? { get set }
    var isOrderPlaced: Bool { get set }
    var orderNumber: String? { get set }
    var estimatedDelivery: String? { get set }
    var cartViewModel: CartViewModel { get }
    var allItems: [BagItemEntity] { get }
    var images: [Int: String] { get }
    
    func placeOrder(paymentMethod: PaymentMethodType, total: Double, address: AddressEntity) async
}
