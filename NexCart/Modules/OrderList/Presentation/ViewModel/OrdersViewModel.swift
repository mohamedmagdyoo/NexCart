//
//  OrdersViewModel.swift
//  NexCart
//
//  Created by shady ramadan on 04/07/2026.
//

import Foundation

enum OrderFilter: String, CaseIterable {
    case all        = "All"
    case inTransit  = "In Transit"
    case delivered  = "Delivered"
    case refunded   = "Refunded"
}

enum OrdersScreenState {
    case loading
    case success
    case empty
    case error(String)
}

@MainActor
final class OrdersViewModel: ObservableObject {
    @Published var orders: [OrderEntity] = []
    @Published var selectedFilter: OrderFilter = .all
    @Published var screenState: OrdersScreenState = .loading
    
    private let fetchOrdersUseCase: FetchOrdersUseCaseProtocol
    
    var filteredOrders: [OrderEntity] {
        switch selectedFilter {
        case .all:       return orders
        case .inTransit: return orders.filter { $0.financialStatus == "pending" }
        case .delivered: return orders.filter { $0.financialStatus == "paid" }
        case .refunded:  return orders.filter { $0.financialStatus == "refunded" }
        }
    }
    
    init(fetchOrdersUseCase: FetchOrdersUseCaseProtocol) {
        self.fetchOrdersUseCase = fetchOrdersUseCase
    }
    
    func loadOrders() async {
        screenState = .loading
        
        guard let userData = UserDefaults.standard.data(forKey: "userEntity"),
              let user = try? JSONDecoder().decode(UserEntity.self, from: userData) else {
            screenState = .error("Couldn't find user info.")
            return
        }
        
        guard let shopifyIdStr = user.shopifyCustomerId,
              let customerId = Int(shopifyIdStr) else {
            screenState = .error("Couldn't find shopify customer ID.")
            return
        }
        
        do {
            let fetched = try await fetchOrdersUseCase.execute(customerId: customerId)
            await MainActor.run{
                orders = fetched.sorted { $0.id > $1.id }
                screenState = fetched.isEmpty ? .empty : .success
            }
            } catch {
            screenState = .error("Couldn't load orders. Pull to refresh.")
        }
    }
    
    func select(_ filter: OrderFilter) {
        selectedFilter = filter
    }
}
