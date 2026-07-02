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
    DIContainer.shared.container.resolve(CartViewModelProtocol.self) as! CartViewModel
  
    private var subtotal: Double {
        cartViewModel.cartData.reduce(into:0.0) {
            $0 + ($1.price * Double($1.quantity))
        }
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

                ScrollView {
                    
                    VStack(spacing: 16) {
                        ForEach($items) { $item in
                            BagItemRow(item: $item) {
                                withAnimation {
                                    items.removeAll { $0.id == item.id }
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
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Your bag")
                .font(AppColor.serif(30, .medium))
                .foregroundColor(AppColor.textPrim)

            Spacer()

            Text("\(items.count) items")
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
            Text("Checkout · $\(total)")
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
    var onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(AppColor.surface)
                    .frame(width: 68, height: 84)
                    .overlay(
                        Image(item.brand)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 68, height: 84)
                            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
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
                        var q=item.quantity
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

