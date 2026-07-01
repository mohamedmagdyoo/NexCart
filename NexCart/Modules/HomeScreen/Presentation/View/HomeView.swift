//
//  HomeView.swift
//  NexCart
//
//  Created by shady ramadan on 28/06/2026.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel = DIContainer.shared.container.resolve(HomeViewModel.self)!
    @State private var heroIndex: Int = 0
    @State private var selectedTab: Int = 0
    @State private var selectedProduct: ProductEntity?

    init() {
    
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            AppColor.bg.ignoresSafeArea()

           
            TabView(selection: $selectedTab) {
                // تابة الـ Home الرئيسية
                NavigationView {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            HomeHeroSection(
                                slides: viewModel.slides,
                                heroIndex: $heroIndex
                            )

                            HomeBrandsSection(
                                brands: viewModel.brands,
                                onBrandSelected: { viewModel.selectBrand(at: $0) }
                            )

                            HomeNewInSection(
                                products: viewModel.products,
                                isLoading: viewModel.isLoading,
                                errorMessage: viewModel.errorMessage,
                                onToggleFavorite: { viewModel.toggleFavorite(at: $0) },
                                onProductSelected: { selectedProduct = $0 },
                                onRetry: { await viewModel.fetchHomeData() }
                            )

                            Spacer().frame(height: 100) // مساحة عشان الـ TabBar مايغطيش المحتوى
                        }
                    }
                    .ignoresSafeArea(edges: .top)
                    .task { await viewModel.fetchHomeData() }
                }
                .navigationViewStyle(.stack) 
                .tag(0)
                
                // تابة الـ Shop
                NavigationView {
                    BrandsListView(
                        viewModel: DIContainer.shared.container.resolve(BrandsListViewModel.self)!
                    )
                    .padding(.bottom, 90)
                }
                .navigationViewStyle(.stack)
                .tag(1)
                
                // تابة الـ Favorites
                NavigationView {
                    FavProductsScreen()
                        .padding(.bottom, 90)
                }
                .navigationViewStyle(.stack)
                .tag(2)
                
               
                NavigationView {
                    Text("Cart View")
                        .font(AppColor.sans(16, .medium))
                        .foregroundColor(AppColor.textPrim)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.bottom, 90)
                }
                .navigationViewStyle(.stack)
                .tag(3)
                
              
                NavigationView {
                    Text("Profile View")
                        .font(AppColor.sans(16, .medium))
                        .foregroundColor(AppColor.textPrim)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.bottom, 90)
                }
                .navigationViewStyle(.stack)
                .tag(4)
            }

           
            HomeTabBar(selectedTab: $selectedTab)
        }
        .background(
            Group {
                if let product = selectedProduct {
                    NavigationLink(
                        destination: ProductDetailView(productEntity: product),
                        isActive: Binding(
                            get: { selectedProduct != nil },
                            set: { if !$0 { selectedProduct = nil } }
                        )
                    ) {
                        EmptyView()
                    }
                }
            }
        )
        .preferredColorScheme(.light)
    }
}



struct TabItemModel {
    let icon: String
    let label: String
}

struct HomeTabBar: View {
    @Binding var selectedTab: Int
    
    let tabs = [
        TabItemModel(icon: "house", label: "Home"),
        TabItemModel(icon: "bag", label: "Shop"),
        TabItemModel(icon: "heart", label: "Favorite"),
        TabItemModel(icon: "cart", label: "Cart"),
        TabItemModel(icon: "person", label: "Profile")
    ]

    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(AppColor.border)
                .frame(height: 0.5)

            HStack(spacing: 0) {
                ForEach(tabs.indices, id: \.self) { i in
                    tabItem(icon: tabs[i].icon, label: tabs[i].label, index: i)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 28)
            .padding(.horizontal, 8)
        }
        .background(AppColor.card)
    }

    private func tabItem(icon: String, label: String, index: Int) -> some View {
        let active = selectedTab == index
        return Button { selectedTab = index } label: {
            VStack(spacing: 5) {
                ZStack {
                    if active {
                        Circle()
                            .fill(AppColor.gold.opacity(0.12))
                            .frame(width: 36, height: 36)
                    }
                    Image(systemName: active ? "\(icon).fill" : icon)
                        .font(.system(size: 19, weight: active ? .regular : .light))
                        .foregroundColor(active ? AppColor.gold : AppColor.textSec)
                }
                Text(label)
                    .font(AppColor.sans(9, .medium))
                    .tracking(0.5)
                    .foregroundColor(active ? AppColor.gold : AppColor.textSec)
            }
            .frame(maxWidth: .infinity)
            .animation(.easeInOut(duration: 0.15), value: selectedTab)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.light)
    }
}
