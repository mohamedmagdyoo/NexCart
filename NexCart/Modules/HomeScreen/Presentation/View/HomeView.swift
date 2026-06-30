import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel = HomeViewModel()
    @State private var heroIndex: Int = 0
    @State private var selectedTab: Int = 0

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                AppColor.bg.ignoresSafeArea()

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
                            onRetry: { await viewModel.fetchHomeData() }
                        )

                        Spacer().frame(height: 100)
                    }
                }
                .ignoresSafeArea(edges: .top)
                .task { await viewModel.fetchHomeData() }

                HomeTabBar(selectedTab: $selectedTab)
            }
            .navigationDestination(for: ProductEntity.self) { product in
                 Text(product.name)
            }
            .navigationDestination(for: BrandEntity.self) { brand in
                 Text(brand.name)
            }
        }
        .preferredColorScheme(.light)
        .ignoresSafeArea(edges: .bottom)
    }
}

struct HomeTabBar: View {

    @Binding var selectedTab: Int

    private let tabs: [(icon: String, label: String)] = [
        ("house", "Home"),
        ("magnifyingglass", "Shop"),
        ("heart", "Saved"),
        ("bag", "Cart"),
        ("person", "Profile"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(AppColor.border)
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

#Preview {
    HomeView()
        .preferredColorScheme(.light)
}
