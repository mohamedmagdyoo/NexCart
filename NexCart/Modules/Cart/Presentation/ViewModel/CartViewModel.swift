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

@MainActor
class CartViewModel: CartViewModelProtocol, ObservableObject {

    @Published var cartState: CartState = .loading
    @Published var cartData: [BagEntity] = []
    private let cartUseCase: CartUseCaseProtocol
    private let applyCouponUseCase: ApplyCouponUseCaseProtocol
    @Published var images: [Int: String] = [:]
    @Published var couponResult: CouponApplicationResult?
    @Published var isApplyingCoupon: Bool = false

    private var appliedCouponCode: String?

    init(cartUseCase: CartUseCaseProtocol, applyCouponUseCase: ApplyCouponUseCaseProtocol) {
        self.cartUseCase = cartUseCase
        self.applyCouponUseCase = applyCouponUseCase
    }
    private var currentCustomerId: Int {
        guard let userData = UserDefaults.standard.data(forKey: "userEntity"),
              let user = try? JSONDecoder().decode(UserEntity.self, from: userData) else {
            print("❌ No user found in UserDefaults")
            return 0
        }
        print("👤 User: \(user.email) | shopifyId: \(user.shopifyCustomerId ?? "nil") | isGuest: \(user.isGuest)")
        guard let shopifyIdStr = user.shopifyCustomerId,
              let id = Int(shopifyIdStr) else {
            print("❌ shopifyCustomerId is nil or not Int")
            return 0
        }
        print("✅ currentCustomerId = \(id)")
        return id
    }

    /// Current subtotal computed live from cartData, so it always reflects
    /// whatever quantities are currently on screen.
    var currentSubtotal: Double {
        cartData.first?.items.reduce(0) { $0 + ($1.price * Double($1.quantity)) } ?? 0.0
    }

    func getAllCart() async {
        cartState = .loading
        do {
            let allCarts = try await cartUseCase.getAllCart(currentCustomerId: currentCustomerId)
            let customerBags = allCarts.filter {
                $0.customer?.id == currentCustomerId
            }
            cartData = mergeBagsIntoSingleCart(customerBags)
            try await getSingleProdut()
            cartState = .success(bagData: cartData)
        } catch {
            cartState = .error(message: "Failed to load cart \(error)")
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

    func deleteFromCart(draftOrderId: String) async -> Bool {
        do {
            try await cartUseCase.deleteFromCart(draftOrderId: draftOrderId)
            return true
        } catch {
            cartState = .error(message: "Failed to delete item")
            return false
        }
    }

    @MainActor
    func applyCoupon(code: String) async {
        guard !code.isEmpty else { return }
        isApplyingCoupon = true
        let result = await applyCouponUseCase.execute(code: code, currentTotal: currentSubtotal)
        couponResult = result
        isApplyingCoupon = false
        // Remember the code (only if it was actually valid) so we can
        // recompute the discount whenever the cart total changes later.
        appliedCouponCode = result.isValid ? code : nil
    }


    @MainActor
    func revalidateCouponIfNeeded() async {
        guard let code = appliedCouponCode else { return }
        isApplyingCoupon = true
        let result = await applyCouponUseCase.execute(code: code, currentTotal: currentSubtotal)
        couponResult = result
        isApplyingCoupon = false
        if !result.isValid {
            appliedCouponCode = nil
        }
    }


    @MainActor
    func updateQuantity(itemId: BagItemEntity.ID, newQuantity: Int) async {
        guard newQuantity > 0,
              let bagIndex = cartData.indices.first,
              let itemIndex = cartData[bagIndex].items.firstIndex(where: { $0.id == itemId }) else { return }

        cartData[bagIndex].items[itemIndex].quantity = newQuantity
        await revalidateCouponIfNeeded()
    }

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
        var order: [String] = []

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


    private func mergeKey(for item: BagItemEntity) -> String {
        "\(item.productId ?? 0)-\(item.size)"
    }
}
