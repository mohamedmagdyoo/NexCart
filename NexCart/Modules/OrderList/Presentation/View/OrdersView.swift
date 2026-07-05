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
            HStack(spacing: 12) {
                ForEach(OrderFilter.allCases, id: \.self) { filter in
                    let isSelected = viewModel.selectedFilter == filter
                    Button {
                        withAnimation { viewModel.select(filter) }
                    } label: {
                        Text(filter.rawValue)
                            .font(AppColor.sans(13, isSelected ? .semibold : .medium))
                            .foregroundColor(isSelected ? .white : AppColor.textSec)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(isSelected ? AppColor.gold : AppColor.surface)
                            )
                            .overlay(
                                Capsule()
                                    .stroke(isSelected ? AppColor.gold : AppColor.border, lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "box.truck")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(AppColor.textSec.opacity(0.5))
            Text("No Orders Yet")
                .font(AppColor.serif(20, .medium))
                .foregroundColor(AppColor.textPrim)
            Text("When you place an order, it will appear here.")
                .font(AppColor.sans(14))
                .foregroundColor(AppColor.textSec)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var ordersList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.filteredOrders) { order in
                    NavigationLink(destination: OrderDetailView(order: order)) {
                        orderCard(order)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(20)
        }
    }
    
    private func orderCard(_ order: OrderEntity) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Order \(order.name)")
                    .font(AppColor.sans(16, .bold))
                    .foregroundColor(AppColor.textPrim)
                Spacer()
                Text(order.statusDisplay)
                    .font(AppColor.sans(12, .semibold))
                    .foregroundColor(statusColor(for: order.financialStatus))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(statusColor(for: order.financialStatus).opacity(0.1))
                    .clipShape(Capsule())
            }
            
            HStack(spacing: 16) {
                if let firstItem = order.lineItems.first {
                    ZStack {
                        AppColor.surface
                        
                        if let url = URL(string: firstItem.imageURL), !firstItem.imageURL.isEmpty {
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 70, height: 70)
                                        .clipped()
                                } else if phase.error != nil {
                                    Image(systemName: "bag").foregroundColor(AppColor.textSec)
                                } else {
                                    ProgressView().tint(AppColor.gold)
                                }
                            }
                        } else {
                            Image(systemName: "bag").foregroundColor(AppColor.textSec)
                        }
                    }
                    .frame(width: 70, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(order.formattedDate)
                        .font(AppColor.sans(13))
                        .foregroundColor(AppColor.textSec)
                    
                    Text("\(order.lineItems.count) Item\(order.lineItems.count > 1 ? "s" : "")")
                        .font(AppColor.sans(14, .medium))
                        .foregroundColor(AppColor.textPrim)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 6) {
                    Text("Total")
                        .font(AppColor.sans(12))
                        .foregroundColor(AppColor.textSec)
                    Text("$\(Int(order.totalPrice))")
                        .font(AppColor.sans(16, .bold))
                        .foregroundColor(AppColor.textPrim)
                }
            }
        }
        .padding(16)
        .background(AppColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
    
    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "paid": return .green
        case "pending": return .orange
        case "refunded": return .red
        default: return AppColor.textSec
        }
    }
}
