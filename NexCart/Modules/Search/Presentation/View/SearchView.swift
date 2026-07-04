//
//  SearchView.swift
//  NexCart
//
//  Created by shady ramadan on 03/07/2026.
//
import SwiftUI
 
struct SearchView: View {
 
    @StateObject var viewModel: SearchViewModel
    @FocusState  private var focused: Bool
    @EnvironmentObject var tabBarManager: TabBarManager
 
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
 
    var body: some View {
        ZStack(alignment: .top) {
            AppColor.bg.ignoresSafeArea()
 
            VStack(spacing: 0) {
                searchBar
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 12)
 
                Divider().opacity(0.3)
 
                ZStack {
                    if viewModel.isIdle          { idlePlaceholder }
                    else if !viewModel.hasResults { emptyResultsView }
                    else                          { resultsList }
                }
                .animation(.easeInOut(duration: 0.15), value: viewModel.isIdle)
                .animation(.easeInOut(duration: 0.15), value: viewModel.hasResults)
            }
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.large)
        .toolbar(.hidden, for: .tabBar)
        .goldBackButton()
        .onAppear {
            tabBarManager.isHidden = true
            focused = true
        }
    }
 
    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColor.textSec)
 
            TextField("Search products or brands…", text: $viewModel.query)
                .font(AppColor.sans(16))
                .foregroundColor(AppColor.textPrim)
                .focused($focused)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .onChange(of: viewModel.query) { _ in
                    viewModel.onQueryChanged()
                }
 
            if !viewModel.query.isEmpty {
                Button(action: viewModel.clearSearch) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(AppColor.textSec)
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(RoundedRectangle(cornerRadius: 14).fill(AppColor.surface))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(focused ? AppColor.gold : AppColor.border, lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.15), value: focused)
    }
 
    private var resultsList: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
 
                if !viewModel.brandResults.isEmpty {
                    sectionHeader("BRANDS", count: viewModel.brandResults.count)
 
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.brandResults) { brand in
                                NavigationLink(
                                    destination: brandDestination(brand: brand)
                                ) {
                                    brandCard(brand: brand)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 4)
                    }
                    .padding(.bottom, 24)
                }
 
                if !viewModel.productResults.isEmpty {
                    sectionHeader("PRODUCTS", count: viewModel.productResults.count)
                        .padding(.bottom, 4)
 
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.productResults) { product in
                            NavigationLink(
                                destination: ProductDetailView(
                                    product: product,
                                    productViewModel: DIContainer.shared.container.resolve(ProductDetailViewModel.self)!
                                )
                            ) {
                                ProductCardView(
                                    product: product,
                                    isFavorited: product.isFavorited,
                                    onFavoriteToggle: {
                                        viewModel.toggleFavorite(productId: product.id)
                                    }
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                }
 
                Color.clear.frame(height: 100)
            }
            .padding(.top, 16)
        }
    }
 
    private func brandCard(brand: SearchViewModel.BrandResult) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                AsyncImage(url: URL(string: brand.imageURL)) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .empty:
                        AppColor.surface.overlay(ProgressView().tint(AppColor.gold))
                    case .failure:
                        brandPlaceholder(name: brand.name)
                    @unknown default:
                        AppColor.surface
                    }
                }
            }
            .frame(width: 130, height: 130)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(AppColor.border, lineWidth: 0.5)
            )
 
            VStack(alignment: .leading, spacing: 2) {
                Text(brand.name)
                    .font(AppColor.sans(13, .semibold))
                    .foregroundColor(AppColor.textPrim)
                    .lineLimit(1)
                Text("\(brand.count) items")
                    .font(AppColor.sans(11))
                    .foregroundColor(AppColor.textSec)
            }
            .padding(.horizontal, 2)
        }
        .frame(width: 130)
    }
 
    private func brandPlaceholder(name: String) -> some View {
        ZStack {
            LinearGradient(
                colors: [AppColor.surface, AppColor.border.opacity(0.6)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            VStack(spacing: 6) {
                Image(systemName: "bag.circle")
                    .font(.system(size: 28, weight: .light))
                    .foregroundColor(AppColor.gold.opacity(0.8))
                Text(String(name.prefix(1)).uppercased())
                    .font(AppColor.serif(18, .bold))
                    .foregroundColor(AppColor.textSec)
            }
        }
    }
 
    @ViewBuilder
    private func brandDestination(brand: SearchViewModel.BrandResult) -> some View {
        let brandEntity = BrandEntity(
            id:       brand.id,
            name:     brand.name,
            imageURL: brand.imageURL
        )

        if let vm = DIContainer.shared.container.resolve(
            BrandProductsViewModel.self,
            argument: brandEntity
        ) {
            BrandProductsView(viewModel: vm)
        } else {
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 32))
                    .foregroundColor(AppColor.textSec)
                Text("Couldn't open this brand. Please try again.")
                    .font(AppColor.sans(14))
                    .foregroundColor(AppColor.textSec)
            }
            .padding(.top, 80)
        }
    }
    private func sectionHeader(_ title: String, count: Int) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Text(title)
                .font(AppColor.sans(11, .semibold))
                .tracking(2)
                .foregroundColor(AppColor.textSec)
            Text("(\(count))")
                .font(AppColor.sans(11))
                .foregroundColor(AppColor.textSec)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
    }
 
    private var idlePlaceholder: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48, weight: .ultraLight))
                .foregroundColor(AppColor.gold.opacity(0.5))
            Text("Search in this collection")
                .font(AppColor.serif(22))
                .foregroundColor(AppColor.textPrim)
            Text("Type a product name or brand")
                .font(AppColor.sans(14))
                .foregroundColor(AppColor.textSec)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 80)
    }
 
    private var emptyResultsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 48, weight: .ultraLight))
                .foregroundColor(AppColor.textSec.opacity(0.5))
            Text("No results found")
                .font(AppColor.serif(22))
                .foregroundColor(AppColor.textPrim)
            Text("Try a different keyword")
                .font(AppColor.sans(14))
                .foregroundColor(AppColor.textSec)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 80)
    }
}
