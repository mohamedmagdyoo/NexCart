import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = DIContainer.shared.container.resolve(HomeViewModel.self)!
    @StateObject private var tabBarManager = TabBarManager()
    @State private var heroIndex: Int = 0
    @State private var selectedTab: Int = 0
    @State private var selectedProductId: Int = 0
    @State private var isNavigatingToProduct: Bool = false
    @State private var isNavigatingToAllProducts: Bool = false
    
    @State private var userEntity: UserEntity?
    @ObservedObject private var appSettings = AppSettings.shared
    
    @State private var isNavigatingToBrand: Bool = false
    @State private var showGuestAlert: Bool = false
    @State private var navigateToSignIn: Bool = false
    @State private var showCouponToast: Bool = false
    
    private var isGuest: Bool {
        guard let data = UserDefaults.standard.data(forKey: "userEntity"),
              let user = try? JSONDecoder().decode(UserEntity.self, from: data)
        else { return true }
        return user.isGuest
    }
    
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
                    .zIndex(1)
            }
        }
        .environmentObject(tabBarManager)
        .animation(.easeInOut(duration: 0.3), value: tabBarManager.isHidden)
        .preferredColorScheme(appSettings.isDarkMode ? .dark : .light)
        .onChange(of: isNavigatingToProduct) { newValue in
            if newValue { tabBarManager.isHidden = true }
        }
        .onChange(of: isNavigatingToAllProducts) { newValue in
            if newValue { tabBarManager.isHidden = true }
        }
        .onChange(of: isNavigatingToBrand) { if $0 { tabBarManager.isHidden = true } }
        .guestAlert(isPresented: $showGuestAlert, navigateToSignIn: $navigateToSignIn)
        .overlay(alignment: .top){
            if showCouponToast {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppColor.gold)
                        .font(.system(size: 16))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Code added to cart!")
                            .font(AppColor.sans(14, .semibold))
                            .foregroundColor(.white)
                        Text("FASHION60 is ready in your cart")
                            .font(AppColor.sans(12))
                            .foregroundColor(Color.white.opacity(0.75))
                    }
                    Spacer()
                }
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.black.opacity(0.85))
                )
                .padding(.horizontal, 20)
                .padding(.top, 56)
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3), value: showCouponToast)
    }
    
    
    
    private var homeTab: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    HomeHeroSection(
                        slides: viewModel.slides,
                        heroIndex: $heroIndex,
                        showCouponToast: $showCouponToast
                    )
                    
                    HomeBrandsSection(
                        brands: viewModel.brands,
                        onBrandSelected: { index in
                            viewModel.selectBrand(at: index)
                            isNavigatingToBrand = true
                        }
                    )
                    
                    HomeNewInSection(
                        products: viewModel.products,
                        isLoading: viewModel.isLoading,
                        errorMessage: viewModel.errorMessage,
                        onToggleFavorite: { index in
                            if isGuest {
                                showGuestAlert = true
                            } else {
                                viewModel.toggleFavorite(at: index)
                            }
                        },
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
                        )
                        .navigationBarBackButtonHidden(true),
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
                    }
                        .navigationBarBackButtonHidden(true),
                    isActive: $isNavigatingToAllProducts
                ) {
                    EmptyView()
                }
                
                if let brand = viewModel.selectedBrand {
                    NavigationLink(
                        destination: Group {
                            if let brandViewModel = DIContainer.shared.container.resolve(
                                BrandProductsViewModel.self,
                                argument: brand
                            ) {
                                BrandProductsView(viewModel: brandViewModel)
                            } else {
                                EmptyView()
                            }
                        }
                            .navigationBarBackButtonHidden(true),
                        isActive: $isNavigatingToBrand
                    ) {
                        EmptyView()
                    }
                }
            }
            .task { await viewModel.fetchHomeData() }
            .onAppear { tabBarManager.isHidden = false }
        }
        .navigationViewStyle(.stack)
        .tag(0)
    }
    
    private var shopTab: some View {
        NavigationStack {
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
            GuestGuard {
                FavProductsScreen()
            }
            .onAppear { tabBarManager.isHidden = false }
        }
        .navigationViewStyle(.stack)
        .tag(2)
    }
    
    private var cartTab: some View {
        NavigationStack {
            GuestGuard {
                BagView()
            }
            .onAppear { tabBarManager.isHidden = false }
        }
        .navigationViewStyle(.stack)
        .tag(3)
    }
    
    private var profileTab: some View {
        NavigationView {
            GuestGuard {
                ProfileView()
            }
            .onAppear { tabBarManager.isHidden = false }
        }
        .navigationViewStyle(.stack)
        .tag(4)
    }
    
    private func profileRow(icon: String, title: String) -> some View {
        HStack(spacing: 16) {
            ZStack {
                AppColor.surface
                Image(systemName: icon)
                    .foregroundColor(AppColor.gold)
                    .font(.system(size: 18))
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            Text(title)
                .font(AppColor.sans(16, .medium))
                .foregroundColor(AppColor.textPrim)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(AppColor.textSec.opacity(0.5))
                .font(.system(size: 14, weight: .semibold))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
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
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}
