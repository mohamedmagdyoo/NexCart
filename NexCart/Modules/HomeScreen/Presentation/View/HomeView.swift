import SwiftUI

struct HomeView: View {

    @StateObject private var viewModel = DIContainer.shared.container.resolve(HomeViewModel.self)!
    @StateObject private var tabBarManager = TabBarManager()
    @State private var heroIndex: Int = 0
    @State private var selectedTab: Int = 0
    @State private var selectedProductId: Int = 0
    @State private var isNavigatingToProduct: Bool = false
    @State private var isNavigatingToAllProducts: Bool = false

    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            AppColor.bg.ignoresSafeArea()

            TabView(selection: $selectedTab) {
                homeTab
                shopTab
                favoritesTab
                cartTab
                profileTab
            }
            .background(AppColor.bg.ignoresSafeArea())
            .ignoresSafeArea(.all, edges: .bottom)

            if !tabBarManager.isHidden {
                HomeTabBar(selectedTab: $selectedTab)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .environmentObject(tabBarManager)
        .animation(.easeInOut(duration: 0.3), value: tabBarManager.isHidden)
        .preferredColorScheme(.light)
        .onChange(of: isNavigatingToProduct) { newValue in
            if newValue { tabBarManager.isHidden = true }
        }
        .onChange(of: isNavigatingToAllProducts) { newValue in
            if newValue { tabBarManager.isHidden = true }
        }
    }

    private var homeTab: some View {
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
                        onProductSelected: { product in
                            selectedProductId = product.id
                            isNavigatingToProduct = true
                        },
                        onRetry: { await viewModel.fetchHomeData() },
                        onSeeAll: { isNavigatingToAllProducts = true }
                    )

                    Spacer().frame(height: 100)
                }
            }
            .ignoresSafeArea(edges: .top)
            .background {
                if let product = viewModel.products.first(where: { $0.id == selectedProductId }) {
                    NavigationLink(
                        destination: ProductDetailView(
                            product: product,
                            productViewModel: DIContainer.shared.container.resolve(ProductDetailViewModel.self)!
                        ),
                        isActive: $isNavigatingToProduct
                    ) {
                        EmptyView()
                    }
                } else {
                    EmptyView()
                }

                NavigationLink(
                    destination: Group {
                        if let collectionViewModel = DIContainer.shared.container.resolve(
                            CollectionProductsViewModel.self,
                            argument: CustomCollectionEntity(id: "all", title: "All Products", imageURL: "")
                        ) {
                            CollectionProductsView(viewModel: collectionViewModel)
                        } else {
                            EmptyView()
                        }
                    },
                    isActive: $isNavigatingToAllProducts
                ) {
                    EmptyView()
                }
            }
            .task { await viewModel.fetchHomeData() }
            .onAppear { tabBarManager.isHidden = false }
        }
        .navigationViewStyle(.stack)
        .tag(0)
    }

    private var shopTab: some View {
        NavigationView {
            CollectionsListView(
                viewModel: DIContainer.shared.container.resolve(CollectionsListViewModel.self)!
            )
            .onAppear { tabBarManager.isHidden = false }
        }
        .navigationViewStyle(.stack)
        .tag(1)
    }

    private var favoritesTab: some View {
        NavigationView {
            FavProductsScreen()
                .onAppear { tabBarManager.isHidden = false }
        }
        .navigationViewStyle(.stack)
        .tag(2)
    }

    @State var couponTextField: String = ""
    
    private var cartTab: some View {
        NavigationView {
            VStack {
                BagView()
                    .padding(.bottom, 75)
                
                TextField("Enter You Coupon", text: $couponTextField)

                Button {
                    print("The Coupon is: \(couponTextField)")

                    let couponUseCase: ApplyCouponUseCaseProtocol = DIContainer.shared.container.resolve(ApplyCouponUseCaseProtocol.self)!

                    Task {
                        let couponResult = await couponUseCase.execute(code: couponTextField, currentTotal: 100)
                        print(" \(couponResult.isValid)")
                        print(" \(couponResult.discountAmount)")
                        print(" \(couponResult.originalTotal)")
                        print(" \(couponResult.finalTotal)")
                        print(" \(couponResult.message)")
                    }

                } label: {
                    Text("Aplay")
                        .font(AppColor.sans(16, .medium))
                        .foregroundColor(AppColor.textPrim)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.bottom, 90)
                }
            }
        }
        .navigationViewStyle(.stack)
        .tag(3)
    }

    private var profileTab: some View {
        NavigationView {
            VStack {
                Text("Profile View")
                    .font(AppColor.sans(16, .medium))
                    .foregroundColor(AppColor.textPrim)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, 90)
                    .onTapGesture {
                        UserDefaults.standard.removeObject(forKey: "userEntity")
                    }
                
                Button {
                    UserDefaults.standard.removeObject(forKey: "userEntity")
                } label: {
                    Text("LogOut")
                        .foregroundColor(.black)
                }
            }
            .onAppear { tabBarManager.isHidden = false }
        }
        .navigationViewStyle(.stack)
        .tag(4)
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
