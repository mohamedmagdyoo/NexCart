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
        errorMessage = nil
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.loadProducts() }
            group.addTask { await self.loadBrandsAndSlides() }
        }
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
        isLoadingProducts = true
        defer { isLoadingProducts = false }
        do {
            var fetchedProducts = try await fetchProductsUseCase.execute()
            
            for i in fetchedProducts.indices {
                fetchedProducts[i].isFavorited = coreDataService.isFavorite(id: fetchedProducts[i].id)
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
