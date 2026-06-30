//
//  BrandProductViewModel.swift
//  NexCart
//
//  Created by shady ramadan on 30/06/2026.
//

import Foundation

struct CategoryEntity: Identifiable, Hashable {
    let id: String
    let name: String
}

final class BrandProductsViewModel: ObservableObject {

    @Published var products: [ProductEntity] = []
    @Published var categories: [CategoryEntity] = [CategoryEntity(id: "all", name: "All")]
    @Published var selectedCategory: CategoryEntity = CategoryEntity(id: "all", name: "All")
    @Published var isLoading = false
    @Published var errorMessage: String?

    let brand: BrandEntity
    private let fetchBrandProductsUseCase: FetchBrandProductsUseCaseProtocol

    init(brand: BrandEntity, fetchBrandProductsUseCase: FetchBrandProductsUseCaseProtocol) {
        self.brand = brand
        self.fetchBrandProductsUseCase = fetchBrandProductsUseCase
    }



    // NOTE: This still matches on the product name as a stand-in, since ProductEntity
    // doesn't currently expose a product type / tags field from the API.
    // If/when ProductsResponseDTO exposes `product_type` or `tags`, switch this to
    // filter on that instead — name-based matching will misclassify items like
    // "Shoe Polish" or anything whose name doesn't literally contain the category word.
    var filteredProducts: [ProductEntity] {
        guard selectedCategory.id != "all" else { return products }

        return products.filter { product in
            let name = product.name.lowercased()
            return name.contains(selectedCategory.name.lowercased())
        }
    }

    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        // Fetch products
        do {
            let fetchedProducts = try await fetchBrandProductsUseCase.execute(collectionId: brand.id)
            #if DEBUG
            print("✅ Brand '\(brand.name)' (id: \(brand.id)) returned \(fetchedProducts.count) products")
            #endif
            products = fetchedProducts
        } catch {
            #if DEBUG
            print("❌ FetchProducts failed for \(brand.name) (id: \(brand.id)): \(error)")
            #endif
            errorMessage = "Couldn't load products. Pull to refresh."
        }
        
        // Fetch categories separately
        do {
            let fetchedCategories = try await fetchBrandProductsUseCase.fetchCategories()
            var allCats = [CategoryEntity(id: "all", name: "All")]
            allCats.append(contentsOf: fetchedCategories)
            categories = allCats
        } catch {
            #if DEBUG
            print("❌ FetchCategories failed: \(error)")
            #endif
        }
        
        isLoading = false
    }

    func select(_ category: CategoryEntity) {
        selectedCategory = category
    }
}
