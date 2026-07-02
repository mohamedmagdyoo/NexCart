//
//  CartScreen.swift
//  NexCart
//
//  Created by Antoneos Philip on 01/07/2026.
//

import Foundation
import SwiftUI

struct BagView: View {
    @State private var promoCode: String = ""
    @StateObject private var cartViewModel: CartViewModel =
    DIContainer.shared.container.resolve(CartViewModel.self)!


    private var allItems: [BagItemEntity] {
        cartViewModel.cartData.flatMap { $0.items }
    }

    private var subtotal: Double {
        allItems.reduce(0.0) { $0 + ($1.price * Double($1.quantity)) }
    }

    private let shipping = 12

    private var total: Double {
        subtotal + Double(shipping)
    }

    var body: some View {
        ZStack {
            AppColor.bg.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                content
            }
        }
        .task {
            await cartViewModel.getAllCart()
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
                cartContent
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
                Image(systemName: "bag")
                    .font(.system(size: 32))
                    .foregroundColor(AppColor.textSec)

                Text("Your bag is empty")
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
                                withAnimation {
                                    bag.items.removeAll { $0.id == item.id }
                                }
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
            Text("Your bag")
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

            Button(action: {}) {
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

    private var summaryCard: some View {
        VStack(spacing: 12) {
            summaryRow(label: "Subtotal", value: Int(subtotal), secondary: true)
            summaryRow(label: "Shipping", value: shipping, secondary: true)

            Divider()
                .background(AppColor.border)
                .padding(.vertical, 4)

            summaryRow(label: "Total", value: Int(total), secondary: false)
        }
        .padding(20)
        .background(AppColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(AppColor.border, lineWidth: 1)
        )
    }

    private func summaryRow(label: String, value: Int, secondary: Bool) -> some View {
        HStack {
            Text(label)
                .font(secondary ? AppColor.sans(15) : AppColor.serif(19, .medium))
                .foregroundColor(secondary ? AppColor.textSec : AppColor.textPrim)

            Spacer()

            Text("$\(value)")
                .font(secondary ? AppColor.sans(15) : AppColor.serif(19, .medium))
                .foregroundColor(secondary ? AppColor.textPrim : AppColor.textPrim)
        }
    }

    private var checkoutButton: some View {
        Button(action: {}) {
            Text("Checkout · $\(Int(total))")
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

                    Text(item.title)
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

                Text("$\(item.price)")
                    .font(AppColor.serif(19, .medium))
                    .foregroundColor(AppColor.textPrim)
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
