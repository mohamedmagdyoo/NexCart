//
//  BrandProductView.swift
//  NexCart
//
//  Created by shady ramadan on 30/06/2026.
//

import Foundation
import SwiftUI

struct BrandProductsView: View {
    @StateObject var viewModel: BrandProductsViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                categoryPills
                countAndFilterRow

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .font(AppColor.sans(14))
                        .foregroundColor(AppColor.textSec)
                        .padding(.top, 60)
                        .frame(maxWidth: .infinity)
                } else if viewModel.filteredProducts.isEmpty {
                    emptyStatePlaceholder
                } else {
                    productGrid
                }
            }
        }
        .background(AppColor.bg.ignoresSafeArea())
        .task { await viewModel.loadProducts() }
        .refreshable { await viewModel.loadProducts() }
    }

    private var header: some View {
        HStack {
            Text(viewModel.brand.name)
                .font(AppColor.serif(34, .medium))
                .foregroundColor(AppColor.textPrim)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }

    private var categoryPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(viewModel.categories) { category in
                    Button {
                        viewModel.select(category)
                    } label: {
                        Text(category.name)
                            .font(AppColor.sans(14, .medium))
                            .foregroundColor(viewModel.selectedCategory.id == category.id ? .white : AppColor.textPrim)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(viewModel.selectedCategory.id == category.id ? AppColor.textPrim : AppColor.surface)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }

    private var countAndFilterRow: some View {
        HStack {
            Text("\(viewModel.filteredProducts.count) Items")
                .font(AppColor.sans(14))
                .foregroundColor(AppColor.textSec)
            Spacer()
        }
        .padding(.horizontal, 20)
    }

    private var productGrid: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            ForEach(viewModel.filteredProducts) { product in
                ProductCardView(product: product, isFavorited: product.isFavorited) {
                    viewModel.toggleFavorite(productId: product.id)
                }
            }
        }
        .padding(.horizontal, 20)
    }

    private var emptyStatePlaceholder: some View {
        VStack(spacing: 20) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(AppColor.textSec)
            
            Text("No Products Found")
                .font(AppColor.serif(20, .medium))
                .foregroundColor(AppColor.textPrim)
            
            Text("We couldn't find any products in this category for \(viewModel.brand.name).")
                .font(AppColor.sans(14))
                .foregroundColor(AppColor.textSec)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}

struct ProductCardView: View {
    let product: ProductEntity
    let isFavorited: Bool
    let onFavoriteToggle: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                AppColor.surface
                AsyncImage(url: URL(string: product.imageURL)) { phase in
                    switch phase {
                    case .success(let image):
                        Color.clear
                            .overlay(
                                image
                                    .resizable()
                                    .scaledToFill()
                            )
                            .clipped()
                    case .empty, .failure:
                        Rectangle().fill(Color.gray.opacity(0.1))
                    @unknown default:
                        EmptyView()
                    }
                }
                Button(action: onFavoriteToggle) {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .foregroundColor(isFavorited ? AppColor.tagSold : AppColor.textPrim)
                        .padding(10)
                        .background(Circle().fill(AppColor.card))
                }
                .padding(10)
            }
            .frame(height: 180)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(product.name)
                .font(AppColor.serif(17, .medium))
                .foregroundColor(AppColor.textPrim)
                .lineLimit(1)

            HStack(spacing: 6) {
                Text("$\(Int(product.price))")
                    .font(AppColor.sans(15, .semibold))
                    .foregroundColor(AppColor.textPrim)
                if let original = product.originalPrice, original > product.price {
                    Text("$\(Int(original))")
                        .font(AppColor.sans(14))
                        .foregroundColor(AppColor.textSec)
                        .strikethrough()
                }
            }
        }
    }
}
