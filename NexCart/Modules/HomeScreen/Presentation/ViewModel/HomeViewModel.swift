import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var slides: [HeroSlideEntity] = []
    @Published var brands: [BrandEntity] = []
    @Published var products: [ProductEntity] = []
    // 1. غيّرنا النوع هنا لـ BrandEntity بدلاً من CustomCollectionEntity
    @Published var selectedBrand: BrandEntity? = nil

    @Published var isLoadingProducts = false
    @Published var isLoadingBrands = false
    @Published var isLoadingHeader = false
    @Published var errorMessage: String?

    var isLoading: Bool { isLoadingProducts || isLoadingBrands || isLoadingHeader }

    private let fetchProductsUseCase: FetchHomeProductsUseCaseProtocol
    private let fetchBrandsUseCase: FetchHomeBrandsUseCaseProtocol
    private let fetchSlidesUseCase: FetchHeroSlidesUseCaseProtocol
    private let coreDataService: ProductsRepoProtocol!

    init(
        fetchProductsUseCase: FetchHomeProductsUseCaseProtocol = FetchHomeProductsUseCase(),
        fetchBrandsUseCase: FetchHomeBrandsUseCaseProtocol = FetchHomeBrandsUseCase(),
        fetchSlidesUseCase: FetchHeroSlidesUseCaseProtocol = FetchHeroSlidesUseCase()
    ) {
        self.fetchProductsUseCase = fetchProductsUseCase
        self.fetchBrandsUseCase = fetchBrandsUseCase
        self.fetchSlidesUseCase = fetchSlidesUseCase
        coreDataService = DIContainer.shared.container.resolve(ProductsRepoProtocol.self)!
    }

    func fetchHomeData() async {
        errorMessage = nil
        async let fetchProducts: () = loadProducts()
        async let fetchBrands: () = loadBrandsAndSlides()
        _ = await [fetchProducts, fetchBrands]
    }

    func toggleFavorite(at index: Int) {
        products[index].isFavorited.toggle()
        let product = products[index]
        if product.isFavorited {
            Task { try await coreDataService.addFavProduct(product: product.mapToFavProduct()) }
        } else {
            Task { try await coreDataService.removeFavProduct(productId: product.id) }
        }
    }

    // 2. هنا بنخزن الـ brand مباشرة بدون تحويل
    func selectBrand(at index: Int) {
        for i in brands.indices { brands[i].isSelected = false }
        brands[index].isSelected = true
        selectedBrand = brands[index]
    }

    private func loadProducts() async {
        isLoadingProducts = true
        defer { isLoadingProducts = false }
        do {
            var fetchedProducts = try await fetchProductsUseCase.execute()
            for i in fetchedProducts.indices {
                fetchedProducts[i].isFavorited = coreDataService.isFavProduct(productId: fetchedProducts[i].id)
            }
            products = fetchedProducts
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadBrandsAndSlides() async {
        isLoadingBrands = true
        defer { isLoadingBrands = false }
        do {
            brands = try await fetchBrandsUseCase.execute()
            slides = fetchSlidesUseCase.execute()
        } catch {
            brands = []
            slides = []
        }
    }
}
