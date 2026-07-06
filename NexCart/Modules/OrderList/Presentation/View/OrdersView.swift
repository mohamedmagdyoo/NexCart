//
//  OrdersView.swift
//  NexCart
//
//  Created by shady ramadan on 04/07/2026.
//

import SwiftUI

struct OrdersView: View {
    @StateObject var viewModel: OrdersViewModel
    @EnvironmentObject var tabBarManager: TabBarManager

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            filterPills
                .padding(.top, 8)
                .padding(.bottom, 12)

            switch viewModel.screenState {
            case .loading:
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            case .empty:
                emptyState
            case .error(let msg):
                Text(msg)
                    .font(AppColor.sans(14))
                    .foregroundColor(AppColor.textSec)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .success:
                ordersList
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(AppColor.bg.ignoresSafeArea())
        .navigationTitle("Orders")
        .navigationBarTitleDisplayMode(.large)
        .goldBackButton()
        .toolbar(.hidden, for: .tabBar)
        .task { await viewModel.loadOrders() }
        .refreshable { await viewModel.loadOrders() }
        .onAppear { tabBarManager.isHidden = true }
    }

    private var filterPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(OrderFilter.allCases, id: \.self) { filter in
                    let isSelected = viewModel.selectedFilter == filter
                    Button {
                        withAnimation { viewModel.select(filter) }
                    } label: {
                        Text(filter.rawValue)
                            .font(AppColor.sans(14, isSelected ? .semibold : .medium))
                            .foregroundColor(isSelected ? .white : AppColor.textSec)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Capsule().fill(isSelected ? Color.black : AppColor.surface))
                            .overlay(Capsule().stroke(isSelected ? Color.clear : AppColor.border, lineWidth: 0.5))
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColor.surface)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(AppColor.border, lineWidth: 0.5))
                .frame(width: 72, height: 72)
                .overlay(
                    Image(systemName: "shippingbox")
                        .font(.system(size: 30, weight: .light))
                        .foregroundColor(AppColor.textSec.opacity(0.5))
                )
                .padding(.bottom, 4)

            Text("No orders yet")
                .font(AppColor.serif(24, .medium))
                .foregroundColor(AppColor.textPrim)

            Text("When you place an order, it will appear here.")
                .font(AppColor.sans(15))
                .foregroundColor(AppColor.textSec)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 40)
    }

    private var ordersList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 14) {
                if viewModel.filteredOrders.isEmpty {
                    filteredEmptyState
                } else {
                    ForEach(viewModel.filteredOrders) { order in
                        NavigationLink(destination: OrderDetailView(order: order)) {
                            orderCard(order)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
    }

    private var filteredEmptyState: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 20)
                .fill(AppColor.surface)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(AppColor.border, lineWidth: 0.5))
                .frame(width: 72, height: 72)
                .overlay(
                    Image(systemName: "tray")
                        .font(.system(size: 28, weight: .light))
                        .foregroundColor(AppColor.textSec.opacity(0.5))
                )
                .padding(.bottom, 4)

            Text("No \(viewModel.selectedFilter.rawValue.lowercased()) orders")
                .font(AppColor.serif(22, .medium))
                .foregroundColor(AppColor.textPrim)

            Text("You don't have any \(viewModel.selectedFilter.rawValue.lowercased()) orders yet.")
                .font(AppColor.sans(15))
                .foregroundColor(AppColor.textSec)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
        .padding(.top, 80)
    }

    private func orderCard(_ order: OrderEntity) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(order.name)
                    .font(AppColor.sans(16, .semibold))
                    .foregroundColor(AppColor.textPrim)
                Spacer()
                statusBadge(for: order.financialStatus, display: order.statusDisplay)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .overlay(
                Rectangle()
                    .fill(AppColor.border)
                    .frame(height: 0.5),
                alignment: .bottom
            )

            HStack(spacing: 16) {
                let firstItem = order.lineItems.first
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColor.surface)
                    .frame(width: 80, height: 80)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColor.border, lineWidth: 0.5))
                    .overlay(
                        Group {
                            if let imageURL = firstItem?.imageURL,
                               let url = URL(string: imageURL),
                               !imageURL.isEmpty {
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image.resizable().scaledToFill()
                                            .frame(width: 80, height: 80)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    } else {
                                        placeholderIcon(count: order.lineItems.count)
                                    }
                                }
                            } else {
                                placeholderIcon(count: order.lineItems.count)
                            }
                        }
                    )

                VStack(alignment: .leading, spacing: 6) {
                    Text(order.formattedDate)
                        .font(AppColor.sans(13))
                        .foregroundColor(AppColor.textSec.opacity(0.7))
                    Text("\(order.lineItems.count) \(order.lineItems.count == 1 ? "item" : "items")")
                        .font(AppColor.sans(15, .medium))
                        .foregroundColor(AppColor.textPrim)
                    if !order.lineItems.isEmpty {
                        Text(order.lineItems.compactMap { $0.vendor.isEmpty ? nil : $0.vendor }
                            .prefix(2).joined(separator: " · "))
                            .font(AppColor.sans(13))
                            .foregroundColor(AppColor.textSec)
                            .lineLimit(1)
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    Text("Total")
                        .font(AppColor.sans(12))
                        .foregroundColor(AppColor.textSec.opacity(0.7))
                    Text("\(order.currency) \(Int(order.totalPrice))")
                        .font(AppColor.sans(18, .semibold))
                        .foregroundColor(AppColor.textPrim)
                }
            }
            .padding(18)
        }
        .background(AppColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(AppColor.border, lineWidth: 0.5))
    }

    private func placeholderIcon(count: Int) -> some View {
        VStack(spacing: 4) {
            Image(systemName: "tshirt")
                .font(.system(size: 22, weight: .light))
                .foregroundColor(AppColor.textSec.opacity(0.5))
            Text("\(count) \(count == 1 ? "item" : "items")")
                .font(AppColor.sans(10))
                .foregroundColor(AppColor.textSec.opacity(0.5))
        }
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
        case "paid":     return Color.green.opacity(0.12)
        case "pending":  return Color.orange.opacity(0.12)
        case "refunded": return Color.red.opacity(0.12)
        default:         return AppColor.surface
        }
    }

    private func statusTextColor(for status: String) -> Color {
        switch status.lowercased() {
        case "paid":     return .green
        case "pending":  return .orange
        case "refunded": return .red
        default:         return AppColor.textSec
        }
    }
}
