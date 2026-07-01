import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var slides: [HeroSlideEntity] = []
    @Published var brands: [BrandEntity] = []
    @Published var products: [ProductEntity] = []

    @Published var isLoadingProducts = false
    @Published var isLoadingBrands = false
    @Published var isLoadingHeader = false
    @Published var errorMessage: String?

    var isLoading: Bool { isLoadingProducts || isLoadingBrands || isLoadingHeader }

    private let fetchProductsUseCase: FetchHomeProductsUseCaseProtocol
    private let fetchBrandsUseCase: FetchHomeBrandsUseCaseProtocol
    private let fetchSlidesUseCase: FetchHeroSlidesUseCaseProtocol
    private let coreDataService = CoreDataService.shared

    init(
        fetchProductsUseCase: FetchHomeProductsUseCaseProtocol = FetchHomeProductsUseCase(),
        fetchBrandsUseCase: FetchHomeBrandsUseCaseProtocol = FetchHomeBrandsUseCase(),
        fetchSlidesUseCase: FetchHeroSlidesUseCaseProtocol = FetchHeroSlidesUseCase()
    ) {
        self.fetchProductsUseCase = fetchProductsUseCase
        self.fetchBrandsUseCase = fetchBrandsUseCase
        self.fetchSlidesUseCase = fetchSlidesUseCase
    }

    func fetchHomeData() async {
        print("🟡 [HomeViewModel] Started fetching all home data...")
        errorMessage = nil
        
        // استخدام async let بيخلي الطلبين يشتغلوا مع بعض في نفس الوقت بشكل آمن جداً
        async let fetchProducts: () = loadProducts()
        async let fetchBrands: () = loadBrandsAndSlides()
        
        await (fetchProducts, fetchBrands)
        print("🟢 [HomeViewModel] Finished fetching all home data!")
    }

    func toggleFavorite(at index: Int) {
        guard products.indices.contains(index) else { return }
        products[index].isFavorited.toggle()
        
        let product = products[index]
        if product.isFavorited {
            coreDataService.saveProductToDatabase(product: product)
        } else {
            coreDataService.deleteProductFromDatabase(id: product.id)
        }
    }

    func selectBrand(at index: Int) {
        for i in brands.indices { brands[i].isSelected = false }
        brands[index].isSelected = true
    }

    private func loadProducts() async {
        print("⏳ [HomeViewModel] loadProducts started")
        isLoadingProducts = true
        
        defer {
            isLoadingProducts = false
            print("✅ [HomeViewModel] loadProducts defer block executed (isLoadingProducts = false)")
        }
        
        do {
            var fetchedProducts = try await fetchProductsUseCase.execute()
            print("📦 [HomeViewModel] Fetched \(fetchedProducts.count) products successfully")
            
            for i in fetchedProducts.indices {
                fetchedProducts[i].isFavorited = coreDataService.isFavorite(id: fetchedProducts[i].id)
            }
            
            products = fetchedProducts
        } catch {
            print("❌ [HomeViewModel] Error fetching products: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        }
    }

    private func loadBrandsAndSlides() async {
        print("⏳ [HomeViewModel] loadBrandsAndSlides started")
        isLoadingBrands = true
        
        defer {
            isLoadingBrands = false
            print("✅ [HomeViewModel] loadBrandsAndSlides defer block executed (isLoadingBrands = false)")
        }
        
        do {
            brands = try await fetchBrandsUseCase.execute()
            print("🏷️ [HomeViewModel] Fetched \(brands.count) brands successfully")
            slides = fetchSlidesUseCase.execute()
        } catch {
            print("❌ [HomeViewModel] Error fetching brands: \(error.localizedDescription)")
            brands = []
            slides = []
        }
    }
}
