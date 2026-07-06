//
//  CollectionProductsView.swift
//  NexCart
//
//  Created by shady ramadan on 02/07/2026.

import Foundation
import SwiftUI

struct CollectionProductsView: View {
    @StateObject var viewModel: CollectionProductsViewModel
    @EnvironmentObject var tabBarManager: TabBarManager
    @State private var showFilterSheet = false
    @State private var showGuestAlert = false
    @State private var navigateToSignIn = false

    private var isGuest: Bool {
        guard let data = UserDefaults.standard.data(forKey: "userEntity"),
              let user = try? JSONDecoder().decode(UserEntity.self, from: data)
        else { return true }
        return user.isGuest
    }

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                countRow

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
            .padding(.bottom, 60)
        }
        .background(AppColor.bg)
        .ignoresSafeArea(.all, edges: .bottom)
        .toolbar(.hidden, for: .tabBar)
        .goldBackButton()
        .task { await viewModel.loadProducts() }
        .refreshable { await viewModel.loadProducts() }
        .onAppear {
            tabBarManager.isHidden = true
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterSheetView(
                brands: viewModel.availableBrands,
                types: viewModel.availableTypes,
                priceRanges: viewModel.availablePriceRanges,
                selectedBrand: $viewModel.selectedBrand,
                selectedType: $viewModel.selectedType,
                selectedPriceRange: $viewModel.selectedPriceRange
            )
        }
        .guestAlert(isPresented: $showGuestAlert, navigateToSignIn: $navigateToSignIn)
    }

    private var header: some View {
        HStack {
            Text(viewModel.collection.title)
                .font(AppColor.serif(34, .medium))
                .foregroundColor(AppColor.textPrim)
            Spacer()
            NavigationLink(
                destination: SearchView(
                    viewModel: SearchViewModel(
                        sourceProducts: viewModel.filteredProducts
                    )
                )
            ) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(AppColor.textPrim)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }

    private var countRow: some View {
        HStack {
            Text("\(viewModel.filteredProducts.count) Items")
                .font(AppColor.sans(14))
                .foregroundColor(AppColor.textSec)
            Spacer()
            Button {
                showFilterSheet = true
            } label: {
                HStack(spacing: 6) {
                    ZStack(alignment: .topTrailing) {
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 13, weight: .semibold))
                        
                        if viewModel.isFilterActive {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 8, height: 8)
                                .offset(x: 4, y: -4)
                        }
                    }
                    Text(viewModel.isFilterActive ? "Filtered" : "Filter")
                        .font(AppColor.sans(14, .medium))
                }
                .foregroundColor(viewModel.isFilterActive ? Color.red : AppColor.textPrim)
            }
        }
        .padding(.horizontal, 20)
    }

    private var productGrid: some View {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.filteredProducts) { product in
                    NavigationLink(
                        destination: ProductDetailView(
                            product: product,
                            productViewModel: DIContainer.shared.container.resolve(ProductDetailViewModel.self)!
                        )
                        .navigationBarBackButtonHidden(true) 
                    ) {
                        ProductCardView(
                            product: product,
                            isFavorited: product.isFavorited,
                            onFavoriteToggle: {
                                if isGuest {
                                    showGuestAlert = true
                                } else {
                                    viewModel.toggleFavorite(productId: product.id)
                                }
                            }
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
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

            Text("We couldn't find any products in \(viewModel.collection.title).")
                .font(AppColor.sans(14))
                .foregroundColor(AppColor.textSec)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}
