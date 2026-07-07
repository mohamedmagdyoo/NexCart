//
//  CompleteOrderView.swift
//  NexCart
//
//  Created by Antoneos Philip on 06/07/2026.
//

import SwiftUI

struct CompleteOrderView: View {
    @StateObject var viewModel: CompleteOrderViewModel
    let paymentMethod: PaymentMethodType
    let total: Double
    let address: AddressEntity

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Group {
            if viewModel.isLoading {
                ZStack {
                    AppColor.bg.ignoresSafeArea()
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.4)
                            .tint(AppColor.pillSel)
                        Text("Placing your order...")
                            .font(AppColor.sans(15))
                            .foregroundColor(AppColor.textSec)
                    }
                }
            } else if viewModel.isOrderPlaced {
                orderPlacedScreen
            } else {
                summaryScreen
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.isOrderPlaced ? "" : "Complete Order")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            if !viewModel.isOrderPlaced {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 40, height: 40)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    }
                }
            }
        }
    }

    private var summaryScreen: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {

                Text("Order Summary")
                    .font(AppColor.serif(26, .medium))
                    .foregroundColor(AppColor.textPrim)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                if viewModel.allItems.isEmpty {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "cart.badge.questionmark")
                                .font(.system(size: 32))
                                .foregroundColor(AppColor.textSec)
                            Text("No items found")
                                .font(AppColor.sans(14))
                                .foregroundColor(AppColor.textSec)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 20)
                } else {
                    VStack(spacing: 12) {
                        ForEach(viewModel.allItems) { item in
                            orderItemRow(item: item)
                        }
                    }
                    .padding(.horizontal, 20)
                }

                Divider().padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 12) {
                    Label("Shipping Address", systemImage: "mappin.and.ellipse")
                        .font(AppColor.sans(14, .semibold))
                        .foregroundColor(AppColor.textSec)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(address.fullName)
                            .font(AppColor.sans(15, .semibold))
                            .foregroundColor(AppColor.textPrim)
                        Text(address.streetAddress)
                            .font(AppColor.sans(14))
                            .foregroundColor(AppColor.textSec)
                        Text("\(address.city), \(address.state) \(address.zip)")
                            .font(AppColor.sans(14))
                            .foregroundColor(AppColor.textSec)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppColor.card)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppColor.border, lineWidth: 1))
                }
                .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 12) {
                    Label("Payment Method", systemImage: "creditcard")
                        .font(AppColor.sans(14, .semibold))
                        .foregroundColor(AppColor.textSec)

                    HStack {
                        Image(systemName: paymentMethod == .applePay ? "apple.logo" : "banknote")
                            .foregroundColor(AppColor.textPrim)
                        Text(paymentMethod == .applePay ? "Apple Pay" : "Cash on Delivery")
                            .font(AppColor.sans(15, .medium))
                            .foregroundColor(AppColor.textPrim)
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(AppColor.pillSel)
                    }
                    .padding(14)
                    .background(AppColor.card)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(AppColor.border, lineWidth: 1))
                }
                .padding(.horizontal, 20)

                HStack {
                    Text("Total")
                        .font(AppColor.serif(18, .medium))
                        .foregroundColor(AppColor.textSec)
                    Spacer()
                    Text(String(format: "$%.2f", total))
                        .font(AppColor.serif(22, .medium))
                        .foregroundColor(AppColor.textPrim)
                }
                .padding(.horizontal, 20)

                if let error = viewModel.error {
                    Text(error)
                        .font(AppColor.sans(14))
                        .foregroundColor(.red)
                        .padding(.horizontal, 20)
                }

                Button(action: {
                    Task {
                        await viewModel.placeOrder(paymentMethod: paymentMethod, total: total, address: address)
                    }
                }) {
                    Text("Complete Payment")
                        .font(AppColor.sans(16, .medium))
                        .foregroundColor(AppColor.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(AppColor.pillSel)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .disabled(viewModel.allItems.isEmpty)
                .opacity(viewModel.allItems.isEmpty ? 0.5 : 1)
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
            .padding(.top, 8)
        }
        .background(AppColor.bg.ignoresSafeArea())
    }

    private func orderItemRow(item: BagItemEntity) -> some View {
        HStack(spacing: 14) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(AppColor.surface)
                .frame(width: 68, height: 84)
                .overlay(
                    Group {
                        if let pid = item.productId,
                           let imageURL = viewModel.images[pid],
                           let url = URL(string: imageURL) {
                            AsyncImage(url: url) { phase in
                                if let img = phase.image {
                                    img.resizable().scaledToFill()
                                        .frame(width: 68, height: 84)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                } else {
                                    Image(systemName: "tshirt")
                                        .font(.system(size: 22))
                                        .foregroundColor(AppColor.textSec.opacity(0.5))
                                }
                            }
                        } else {
                            Image(systemName: "tshirt")
                                .font(.system(size: 22))
                                .foregroundColor(AppColor.textSec.opacity(0.5))
                        }
                    }
                )

            VStack(alignment: .leading, spacing: 4) {
                if !item.brand.isEmpty {
                    Text(item.brand)
                        .font(AppColor.sans(11, .medium))
                        .tracking(1)
                        .foregroundColor(AppColor.textSec)
                }
                Text(cleanTitle(item.title))
                    .font(AppColor.serif(16, .medium))
                    .foregroundColor(AppColor.textPrim)
                    .lineLimit(2)
                if !item.size.isEmpty {
                    Text(item.size)
                        .font(AppColor.sans(13))
                        .foregroundColor(AppColor.textSec)
                }
                Text("Qty: \(item.quantity)")
                    .font(AppColor.sans(13))
                    .foregroundColor(AppColor.textSec)
            }

            Spacer()

            Text(String(format: "$%.2f", item.price * Double(item.quantity)))
                .font(AppColor.serif(16, .medium))
                .foregroundColor(AppColor.textPrim)
        }
        .padding(14)
        .background(AppColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppColor.border, lineWidth: 1))
    }

    private func cleanTitle(_ title: String) -> String {
        let parts = title.components(separatedBy: "|")
        if parts.count > 1 {
            return parts[1].trimmingCharacters(in: .whitespaces)
        }
        return title.trimmingCharacters(in: .whitespaces)
    }

    private var orderPlacedScreen: some View {
        VStack(spacing: 24) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color(red: 0.95, green: 0.91, blue: 0.88))
                    .frame(width: 110, height: 110)
                Circle()
                    .fill(Color(red: 0.78, green: 0.42, blue: 0.23))
                    .frame(width: 76, height: 76)
                Image(systemName: "checkmark")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundColor(.white)
            }

            VStack(spacing: 10) {
                Text("Order placed.")
                    .font(AppColor.serif(34, .medium))
                    .foregroundColor(.black)
                Text("Thank you, \(address.fullName.components(separatedBy: " ").first ?? "Customer"). We're preparing your pieces and will share tracking shortly.")
                    .font(AppColor.sans(15))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            VStack(spacing: 16) {
                detailRow(title: "Order number", value: viewModel.orderNumber ?? "N/A")
                Divider()
                detailRow(title: "Total", value: String(format: "$%.2f", total))
                Divider()
                detailRow(title: "Estimated delivery", value: viewModel.estimatedDelivery ?? "TBD")
                Divider()
                detailRow(title: "Shipping to", value: "\(address.streetAddress), \(address.city)")
            }
            .padding(20)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.25), lineWidth: 1))
            .padding(.horizontal, 24)

            Spacer()
            
            Button(action: {
                
            }) {
                Text("Continue Shopping")
                    .font(AppColor.sans(16, .medium))
                    .foregroundColor(AppColor.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(AppColor.pillSel)
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 110)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
    }

    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(AppColor.sans(14))
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(AppColor.sans(14, .semibold))
                .foregroundColor(.black)
        }
    }
}

