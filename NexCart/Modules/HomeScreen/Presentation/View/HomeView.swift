import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = DIContainer.shared.container.resolve(HomeViewModel.self)!
    @StateObject private var tabBarManager = TabBarManager()
    @State private var heroIndex: Int = 0
    @State private var selectedTab: Int = 0
    @State private var selectedProductId: Int = 0
    @State private var isNavigatingToProduct: Bool = false
    @State private var isNavigatingToAllProducts: Bool = false
    @State private var isNavigatingToBrand: Bool = false
    @State private var showGuestAlert: Bool = false
    @State private var navigateToSignIn: Bool = false

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
        .preferredColorScheme(.light)
        .onChange(of: isNavigatingToProduct) { if $0 { tabBarManager.isHidden = true } }
        .onChange(of: isNavigatingToAllProducts) { if $0 { tabBarManager.isHidden = true } }
        .onChange(of: isNavigatingToBrand) { if $0 { tabBarManager.isHidden = true } }
        .guestAlert(isPresented: $showGuestAlert, navigateToSignIn: $navigateToSignIn)
    }
    
    // MARK: - Home Tab
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
    
    // MARK: - Shop Tab
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
    
    // MARK: - Favorites Tab (محمية بـ GuestGuard)
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
    
    // MARK: - Cart Tab (محمية بـ GuestGuard)
    private var cartTab: some View {
        NavigationView {
            GuestGuard {
                // استبدل بـ CartView() لما تكون جاهزة
                Text("Cart View")
                    .font(AppColor.sans(16, .medium))
                    .foregroundColor(AppColor.textPrim)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, 90)
            }
            .onAppear { tabBarManager.isHidden = false }
        }
        .navigationViewStyle(.stack)
        .tag(3)
    }
    
    // MARK: - Profile Tab (محمية بـ GuestGuard)
    private var profileTab: some View {
        NavigationView {
            GuestGuard {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(AppColor.surface)
                                .frame(width: 80, height: 80)
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 76))
                                .foregroundColor(AppColor.gold.opacity(0.5))
                        }
                    }
                    .padding(.top, 20)
                    
                    VStack(spacing: 0) {
                        NavigationLink {
                            if let ordersViewModel = DIContainer.shared.container.resolve(OrdersViewModel.self) {
                                OrdersView(viewModel: ordersViewModel)
                            } else {
                                Text("Orders ViewModel not registered").foregroundColor(.red)
                            }
                        } label: {
                            profileRow(icon: "box.truck", title: "My Orders")
                        }
                        
                        Divider().background(AppColor.border).padding(.leading, 56)
                        
                        NavigationLink {
                            Text("Addresses View")
                        } label: {
                            profileRow(icon: "map", title: "Shipping Addresses")
                        }
                        
                        Divider().background(AppColor.border).padding(.leading, 56)
                        
                        NavigationLink {
                            Text("Settings View")
                        } label: {
                            profileRow(icon: "gearshape", title: "Settings")
                        }
                    }
                    .background(AppColor.card)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.03), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 20)
                    
                    Spacer()
                    
                    Button {
                        UserDefaults.standard.removeObject(forKey: "userEntity")
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Log Out")
                        }
                        .font(AppColor.sans(16, .bold))
                        .foregroundColor(AppColor.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.red.opacity(0.8))
                        .clipShape(Capsule())
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
                .background(AppColor.bg.ignoresSafeArea())
                .navigationTitle("Profile")
                .navigationBarHidden(true)
                .foregroundColor(AppColor.textPrim)

        NavigationStack {
            VStack {
                Text("Profile View")
                    .font(AppColor.sans(16, .medium))
                    .foregroundColor(AppColor.textPrim)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.bottom, 90)
 (Last touches of finishing apple pay feature)
                
                Button {
                    UserDefaults.standard.removeObject(forKey: "userEntity")
                } label: {
                    Text("LogOut")
                        .foregroundColor(.black)
                }
                
                NavigationLink {
                    AddressListView(
                        viewModel: DIContainer.shared.container.resolve(AddressViewModel.self)!,
                        ownerUserId: userEntity?.id ?? "Me"
                    )
                } label: {
                    Text("NavToAddress")
                        .foregroundColor(.black)
                }

                NavigationLink{
                    
                    CheckoutView(viewModel: DIContainer.shared.container.resolve(CheckoutViewModel.self)!, total: 1005)
                }label: {
                    Text("CheckOut")
                        .foregroundColor(.black)
                }

                
                Spacer()
            }
            .onAppear { tabBarManager.isHidden = false }
        }
        .navigationViewStyle(.stack)
        .tag(4)
    }
    
    // MARK: - Profile Row Helper
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
    
    // MARK: - Tab Bar
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
