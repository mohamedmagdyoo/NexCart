//
//  CartViewModel.swift
//  NexCart
//
//  Created by Antoneos Philip on 01/07/2026.
//

import Foundation
enum CartState{
    case success(bagData:[BagEntity])
    case loading
    case error(message:String)
    
}

class CartViewModel: CartViewModelProtocol, ObservableObject {

    @Published var cartState: CartState = .loading
    @Published var cartData: [BagEntity] = []
    private let currentCustomerId = 10880560562482
    private let cartUseCase: CartUseCaseProtocol
    @Published var images: [Int: String] = [:]

    init(cartUseCase: CartUseCaseProtocol) {
        self.cartUseCase = cartUseCase
    }

    func getAllCart() async {
        cartState = .loading
        do {
            let allCarts = try await cartUseCase.getAllCart()
            let customerBags = allCarts.filter { $0.customer?.id == currentCustomerId }
            cartData = mergeBagsIntoSingleCart(customerBags)
            try await getSingleProdut()
            cartState = .success(bagData: cartData)
        } catch {
            cartState = .error(message: "Failed to load cart")
        }
    }

    func getSingleProdut() async {
        do {
            guard let items = cartData.first?.items else { return }
            for item in items {
                guard let productId = item.productId else { continue }
                let product = try await cartUseCase.getSingleProduct(productId: productId)
                images[product.id] = product.imageURL
            }
        } catch {
            cartState = .error(message: "Failed to load product")
        }
    }

    // MARK: - Merging across all of the customer's draft orders

    /// Flattens every draft order's line items into one list and combines
    /// items that share the same product + variant (size/color), summing quantity.
    private func mergeBagsIntoSingleCart(_ bags: [BagEntity]) -> [BagEntity] {
        guard !bags.isEmpty else { return [] }

        let allItems = bags.flatMap { $0.items }
        let mergedItems = mergeDuplicateItems(allItems)

        let subtotal = mergedItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
        let shipping = bags.reduce(0) { $0 + $1.shipping }
        let total = subtotal + shipping

        let unifiedCart = BagEntity(
            id: bags.first?.id ?? 0,
            itemCount: mergedItems.reduce(0) { $0 + $1.quantity },
            items: mergedItems,
            subtotal: subtotal,
            shipping: shipping,
            total: total,
            currency: bags.first?.currency ?? "USD",
            customer: bags.first?.customer
        )

        return [unifiedCart]
    }

    private func mergeDuplicateItems(_ items: [BagItemEntity]) -> [BagItemEntity] {
        var merged: [String: BagItemEntity] = [:]
        var order: [String] = []   // preserves first-seen ordering

        for item in items {
            let key = mergeKey(for: item)
            if var existing = merged[key] {
                existing.quantity += item.quantity
                merged[key] = existing
            } else {
                merged[key] = item
                order.append(key)
            }
        }
        return order.compactMap { merged[$0] }
    }

    /// Note: `size` already stores the full variant string (e.g. "OS / black",
    /// "4 / burgandy") which encodes both size AND color, so this single key
    /// naturally merges on product + size + color without a separate field.
    private func mergeKey(for item: BagItemEntity) -> String {
        "\(item.productId ?? 0)-\(item.size)"
    }
}
