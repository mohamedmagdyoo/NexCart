//
//  AppRouter.swift
//  NexCart
//
//  Created by Mohamed Magdy on 08/07/2026.
//

import Foundation
import SwiftUI

enum CartRoute: Hashable {
    case checkout(total: Double)
    case completeOrder(
        payment: PaymentMethodType,
        total: Double,
        address: AddressEntity
    )
}

final class AppRouter: ObservableObject {

    static let shared = AppRouter()

    @Published var selectedTab = 0
    @Published var cartPath = NavigationPath()

    func returnToHomeFromCheckout() {
        cartPath = NavigationPath()   // clear checkout/cart stack
        selectedTab = 0               // switch to Home tab
    }
}
