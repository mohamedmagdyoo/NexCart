//
//  OrderDetailsView.swift
//  NexCart
//
//  Created by shady ramadan on 04/07/2026.
//

import SwiftUI

struct OrderDetailView: View {
    let order: OrderEntity
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var appSettings = AppSettings.shared

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                headerCard
                itemsSection
                summarySection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(AppColor.bg.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .goldBackButton()
        .toolbar(.hidden, for: .tabBar)
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(order.name)
                        .font(AppColor.serif(30, .medium))
                        .foregroundColor(AppColor.textPrim)
                    Text(order.formattedDate)
                        .font(AppColor.sans(14))
                        .foregroundColor(AppColor.textSec.opacity(0.7))
                }
                Spacer()
                statusBadge(for: order.financialStatus, display: order.statusDisplay)
            }

            Divider().background(AppColor.border)

            HStack(spacing: 0) {
                metaItem(label: "ITEMS", value: "\(order.lineItems.count)")
                Spacer()
                metaItem(label: "CURRENCY", value: appSettings.selectedCurrency)
                Spacer()
                metaItem(label: "ORDER NO.", value: "#\(order.orderNumber)")
            }
        }
        .padding(20)
        .background(AppColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppColor.border, lineWidth: 0.5))
    }

    private func metaItem(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label)
                .font(AppColor.sans(11))
                .foregroundColor(AppColor.textSec.opacity(0.6))
                .tracking(0.5)
            Text(value)
                .font(AppColor.sans(15, .medium))
                .foregroundColor(AppColor.textPrim)
        }
    }

    private var itemsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Items in your order")
                .font(AppColor.sans(16))
                .foregroundColor(AppColor.textSec)
                .padding(.horizontal, 4)

            VStack(spacing: 12) {
                ForEach(order.lineItems) { item in
                    itemRow(item)
                }
            }
        }
    }

    private func itemRow(_ item: OrderLineItemEntity) -> some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColor.surface)
                .frame(width: 80, height: 80)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColor.border, lineWidth: 0.5))
                .overlay(
                    Group {
                        if let url = URL(string: item.imageURL), !item.imageURL.isEmpty {
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image.resizable().scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                } else {
                                    placeholderIcon
                                }
                            }
                        } else {
                            placeholderIcon
                        }
                    }
                )

            VStack(alignment: .leading, spacing: 6) {
                if !item.vendor.isEmpty {
                    Text(item.vendor.uppercased())
                        .font(AppColor.sans(11))
                        .foregroundColor(AppColor.textSec.opacity(0.6))
                        .tracking(0.8)
                }
                Text(item.title)
                    .font(AppColor.sans(15, .medium))
                    .foregroundColor(AppColor.textPrim)
                    .lineLimit(2)
                if !item.variantTitle.isEmpty {
                    Text(item.variantTitle)
                        .font(AppColor.sans(13))
                        .foregroundColor(AppColor.textSec)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text("\(appSettings.selectedCurrency) \(Int(item.price * appSettings.currencyRate))")
                    .font(AppColor.sans(16, .semibold))
                    .foregroundColor(AppColor.textPrim)
                Text("Qty: \(item.quantity)")
                    .font(AppColor.sans(13))
                    .foregroundColor(AppColor.textSec.opacity(0.7))
            }
        }
        .padding(16)
        .background(AppColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppColor.border, lineWidth: 0.5))
    }

    private var placeholderIcon: some View {
        Image(systemName: "tshirt")
            .font(.system(size: 24, weight: .light))
            .foregroundColor(AppColor.textSec.opacity(0.5))
    }

    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order summary")
                .font(AppColor.sans(16))
                .foregroundColor(AppColor.textSec)
                .padding(.horizontal, 4)

            VStack(spacing: 0) {
                summaryRow(label: "Subtotal", value: "\(appSettings.selectedCurrency) \(Int(order.totalPrice * appSettings.currencyRate))")
                Divider().background(AppColor.border).padding(.horizontal, 16)
                HStack {
                    Text("Total")
                        .font(AppColor.sans(17, .semibold))
                        .foregroundColor(AppColor.textPrim)
                    Spacer()
                    Text("\(appSettings.selectedCurrency) \(Int(order.totalPrice * appSettings.currencyRate))")
                        .font(AppColor.sans(20, .semibold))
                        .foregroundColor(AppColor.textPrim)
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 16)
            }
            .background(AppColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppColor.border, lineWidth: 0.5))
        }
    }

    private func summaryRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(AppColor.sans(15))
                .foregroundColor(AppColor.textSec)
            Spacer()
            Text(value)
                .font(AppColor.sans(15, .medium))
                .foregroundColor(AppColor.textPrim)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
    }

    @ViewBuilder
    private func statusBadge(for status: String, display: String) -> some View {
        Text(display)
            .font(AppColor.sans(13, .semibold))
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(statusBgColor(for: status))
            .foregroundColor(statusTextColor(for: status))
            .clipShape(Capsule())
    }

    private func statusBgColor(for status: String) -> Color {
        switch status.lowercased() {
        case "paid":                        return Color.green.opacity(0.12)
        case "pending":                     return Color.orange.opacity(0.12)
        case "refunded", "voided":          return Color.red.opacity(0.12)
        case "in_transit", "in transit":    return Color.yellow.opacity(0.15)
        case "partially_paid":              return Color.blue.opacity(0.12)
        default:                            return AppColor.surface
        }
    }

    private func statusTextColor(for status: String) -> Color {
        switch status.lowercased() {
        case "paid":                        return .green
        case "pending":                     return .orange
        case "refunded", "voided":          return .red
        case "in_transit", "in transit":    return Color(red: 0.7, green: 0.55, blue: 0.0)
        case "partially_paid":              return .blue
        default:                            return AppColor.textSec
        }
    }
}
