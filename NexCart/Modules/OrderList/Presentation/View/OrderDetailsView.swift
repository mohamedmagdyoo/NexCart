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
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                headerSection
                productsSection
                summarySection
            }
            .padding(.vertical, 20)
        }
        .background(AppColor.bg.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColor.textPrim)
                        .frame(width: 40, height: 40)
                        .background(AppColor.card)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Order \(order.name)")
                .font(AppColor.serif(28, .bold))
                .foregroundColor(AppColor.textPrim)
            
            HStack(spacing: 12) {
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                    Text(order.formattedDate)
                }
                .font(AppColor.sans(14))
                .foregroundColor(AppColor.textSec)
                
                Circle()
                    .fill(AppColor.border)
                    .frame(width: 4, height: 4)
                
                Text(order.statusDisplay)
                    .font(AppColor.sans(14, .semibold))
                    .foregroundColor(statusColor(for: order.financialStatus))
            }
        }
        .padding(.horizontal, 20)
    }
    
    private var productsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Items in your order")
                .font(AppColor.sans(18, .bold))
                .foregroundColor(AppColor.textPrim)
                .padding(.horizontal, 20)
            
            VStack(spacing: 16) {
                ForEach(order.lineItems) { item in
                    HStack(spacing: 16) {
                        ZStack {
                            AppColor.surface
                            
                            if let url = URL(string: item.imageURL), !item.imageURL.isEmpty {
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 80)
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
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text(item.vendor.uppercased())
                                .font(AppColor.sans(10, .semibold))
                                .foregroundColor(AppColor.textSec)
                                .tracking(1)
                            
                            Text(item.title)
                                .font(AppColor.sans(15, .medium))
                                .foregroundColor(AppColor.textPrim)
                                .lineLimit(2)
                            
                            HStack {
                                Text("Qty: \(item.quantity)")
                                    .font(AppColor.sans(13))
                                    .foregroundColor(AppColor.textSec)
                                Spacer()
                                Text("$\(Int(item.price))")
                                    .font(AppColor.sans(15, .bold))
                                    .foregroundColor(AppColor.textPrim)
                            }
                        }
                    }
                    .padding(16)
                    .background(AppColor.card)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private var summarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Order Summary")
                .font(AppColor.sans(18, .bold))
                .foregroundColor(AppColor.textPrim)
            
            VStack(spacing: 12) {
                summaryRow(title: "Subtotal", value: "$\(Int(order.totalPrice))")
                summaryRow(title: "Shipping", value: "Free")
                
                Divider()
                    .background(AppColor.border)
                    .padding(.vertical, 8)
                
                HStack {
                    Text("Total")
                        .font(AppColor.sans(16, .bold))
                        .foregroundColor(AppColor.textPrim)
                    Spacer()
                    Text("$\(Int(order.totalPrice))")
                        .font(AppColor.sans(20, .bold))
                        .foregroundColor(AppColor.gold)
                }
            }
            .padding(20)
            .background(AppColor.card)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
    }
    
    private func summaryRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(AppColor.sans(14))
                .foregroundColor(AppColor.textSec)
            Spacer()
            Text(value)
                .font(AppColor.sans(14, .medium))
                .foregroundColor(AppColor.textPrim)
        }
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
