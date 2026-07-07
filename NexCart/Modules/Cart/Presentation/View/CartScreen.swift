//
//  CartScreen.swift
//  NexCart
//
//  Created by Antoneos Philip on 01/07/2026.
//

import Foundation
import SwiftUI

struct BagView: View {
    @AppStorage("pendingCouponCode") private var promoCode: String = ""
    @StateObject private var cartViewModel: CartViewModel =
    DIContainer.shared.container.resolve(CartViewModel.self)!

    @State private var itemToDelete: BagItemEntity?
    @State private var bagIdForDeletion: Int?
    @State private var showDeleteAlert = false
    @State private var showToast = false
    @State private var toastMessage = ""


    private var allItems: [BagItemEntity] {
        cartViewModel.cartData.flatMap { $0.items }
    }

    private var subtotal: Double {
        allItems.reduce(0.0) { $0 + ($1.price * Double($1.quantity)) }
    }

    private var total: Double {
        if let result = cartViewModel.couponResult, result.isValid {
            return result.finalTotal
        }
        return subtotal
    }

    var body: some View {
        ZStack {
            AppColor.bg.ignoresSafeArea()

            ScrollView{
                VStack(spacing: 0) {
                    header

                    content
                }
            }
        }
        .task {
            await cartViewModel.getAllCart()
        }
        .alert("Are you sure to delete?", isPresented: $showDeleteAlert) {
            Button("Delete", role: .destructive) {
                if let item = itemToDelete, let bagId = bagIdForDeletion {
                    deleteItem(item, fromBagId: bagId)
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .overlay(
            toastView
        )
    }

    @ViewBuilder
    private var toastView: some View {
        if showToast {
            VStack {
                Spacer()
                Text(toastMessage)
                    .font(AppColor.sans(14, .medium))
                    .foregroundColor(AppColor.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.8))
                    .clipShape(Capsule())
                    .padding(.bottom, 100)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            .animation(.easeInOut, value: showToast)
        }
    }

    private func deleteItem(_ item: BagItemEntity, fromBagId bagId: Int) {
        guard let bagIndex = cartViewModel.cartData.firstIndex(where: { $0.id == bagId }),
              let itemIndex = cartViewModel.cartData[bagIndex].items.firstIndex(where: { $0.id == item.id }) else { return }

        let removedItem = cartViewModel.cartData[bagIndex].items.remove(at: itemIndex)

        Task {
            let success = await cartViewModel.deleteFromCart(draftOrderId: String(item.drafOrderId))
            if success {
                showToastMessage("Item deleted successfully")
            } else {
                withAnimation {
                    cartViewModel.cartData[bagIndex].items.insert(removedItem, at: itemIndex)
                }
                showToastMessage("Failed to delete item")
            }
        }
    }

    private func showToastMessage(_ message: String) {
        toastMessage = message
        withAnimation {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                showToast = false
            }
        }
    }


    @ViewBuilder
    private var content: some View {
        switch cartViewModel.cartState {
        case .loading:
            loadingView

        case .error(let message):
            errorView(message: message)

        case .success:
            if allItems.isEmpty {
                emptyView
            } else {
                Group {
                    cartContent
                }
            }
        }
    }

    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
                .tint(AppColor.textPrim)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private func errorView(message: String) -> some View {
        VStack {
            Spacer()
            VStack(spacing: 14) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 32))
                    .foregroundColor(AppColor.textSec)

                Text(message)
                    .font(AppColor.sans(15))
                    .foregroundColor(AppColor.textSec)
                    .multilineTextAlignment(.center)

                Button(action: {
                    Task { await cartViewModel.getAllCart() }
                }) {
                    Text("Retry")
                        .font(AppColor.sans(15, .medium))
                        .foregroundColor(AppColor.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(AppColor.pillSel)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 32)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var emptyView: some View {
        VStack {
            Spacer()
            VStack(spacing: 14) {
                Image(systemName: "cart")
                    .font(.system(size: 32))
                    .foregroundColor(AppColor.textSec)

                Text("Your cart is empty")
                    .font(AppColor.sans(15))
                    .foregroundColor(AppColor.textSec)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var cartContent: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach($cartViewModel.cartData) { $bag in
                        ForEach($bag.items) { $item in
                            BagItemRow(item: $item,image: cartViewModel.images[item.productId ?? 0] ?? "") {
                                itemToDelete = item
                                bagIdForDeletion = bag.id
                                showDeleteAlert = true
                            }
                        }
                    }

                    promoField

                    summaryCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }

            checkoutButton
        }
    }


    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Your cart")
                .font(AppColor.serif(30, .medium))
                .foregroundColor(AppColor.textPrim)

            Spacer()

            Text("\(allItems.count) items")
                .font(AppColor.sans(14))
                .foregroundColor(AppColor.textSec)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 4)
    }

    private var promoField: some View {
        HStack(spacing: 12) {
            HStack(spacing: 10) {
                Image(systemName: "tag")
                    .font(.system(size: 15))
                    .foregroundColor(AppColor.textSec)

                TextField("Promo code", text: $promoCode)
                    .font(AppColor.sans(15))
                    .foregroundColor(AppColor.textPrim)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(AppColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(AppColor.border, lineWidth: 1)
            )

            Button(action: {
                Task {
                    await cartViewModel.applyCoupon(code: promoCode)
                    if let result = cartViewModel.couponResult {
                        showToastMessage(result.message)
                    }
                    promoCode = ""
                }
                
            }) {
                if cartViewModel.isApplyingCoupon {
                    ProgressView()
                        .tint(AppColor.white)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 14)
                        .background(AppColor.pillSel)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                } else {
                    Text("Apply")
                        .font(AppColor.sans(15, .medium))
                        .foregroundColor(AppColor.white)
                        .padding(.horizontal, 22)
                        .padding(.vertical, 14)
                        .background(AppColor.pillSel)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
        }
    }

    private var summaryCard: some View {
        VStack(spacing: 12) {
            summaryRow(label: "Subtotal", value: subtotal, secondary: true)
            
            if let result = cartViewModel.couponResult, result.isValid {
                summaryRow(label: "Discount", value: result.discountAmount, secondary: true, isDiscount: true)
            }

            Divider()
                .background(AppColor.border)
                .padding(.vertical, 4)

            summaryRow(label: "Total", value: total, secondary: false)
        }
        .padding(20)
        .background(AppColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(AppColor.border, lineWidth: 1)
        )
    }

    private func summaryRow(label: String, value: Double, secondary: Bool, isDiscount: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(secondary ? AppColor.sans(15) : AppColor.serif(19, .medium))
                .foregroundColor(secondary ? AppColor.textSec : AppColor.textPrim)

            Spacer()

            Text(isDiscount ? "-$\(value, specifier: "%.2f")" : "$\(value, specifier: "%.2f")")
                .font(secondary ? AppColor.sans(15) : AppColor.serif(19, .medium))
                .foregroundColor(isDiscount ? .green : (secondary ? AppColor.textPrim : AppColor.textPrim))
        }
    }

    private var checkoutButton: some View {
        Button(action: {}) {
            Text("Checkout · $\(total, specifier: "%.2f")")
                .font(AppColor.sans(16, .medium))
                .foregroundColor(AppColor.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(AppColor.pillSel)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
        .padding(.top, 8)
    }
}

struct BagItemRow: View {
    @Binding var item: BagItemEntity
     var image:String
    var onDelete: () -> Void

    private var displayName: String {
        let parts = item.title.components(separatedBy: "|")
        if parts.count > 1 {
            return parts[1].trimmingCharacters(in: .whitespaces)
        }
        return item.title.trimmingCharacters(in: .whitespaces)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(AppColor.surface)
                    .frame(width: 68, height: 84)
                    .overlay(
                        AsyncImage(url: URL(string: image)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 68, height: 84)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.brand)
                        .font(AppColor.sans(11, .medium))
                        .tracking(1)
                        .foregroundColor(AppColor.textSec)

                    Text(displayName)
                        .font(AppColor.serif(18, .medium))
                        .foregroundColor(AppColor.textPrim)

                    Text(item.size)
                        .font(AppColor.sans(14))
                        .foregroundColor(AppColor.textSec)
                }

                Spacer()

                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 15))
                        .foregroundColor(AppColor.textSec)
                }
            }

            HStack {
                HStack(spacing: 0) {
                    stepperButton(icon: "minus") {
                        if item.quantity > 1 {
                            item.quantity -= 1
                        }
                    }

                    Text("\(item.quantity)")
                        .font(AppColor.sans(15, .medium))
                        .foregroundColor(AppColor.textPrim)
                        .frame(width: 32)

                    stepperButton(icon: "plus") {
                        item.quantity += 1
                    }
                }
                .background(AppColor.pill)
                .clipShape(Capsule())

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text("$\(item.price, specifier: "%.2f")")
                        .font(AppColor.serif(19, .medium))
                        .foregroundColor(AppColor.textPrim)

                    Text("per piece")
                        .font(AppColor.sans(12))
                        .foregroundColor(AppColor.textSec)
                }
            }
        }
        .padding(16)
        .background(AppColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(AppColor.border, lineWidth: 1)
        )
    }

    private func stepperButton(icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(AppColor.textPrim)
                .frame(width: 32, height: 32)
        }
    }
}
