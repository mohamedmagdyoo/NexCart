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
    @Published var selectedCategory: CategoryEntity = CategoryEntity(id: "all", name: "All")
    @Published var isLoading = false
    @Published var errorMessage: String?

    let brand: BrandEntity
    private let fetchBrandProductsUseCase: FetchBrandProductsUseCaseProtocol

    init(brand: BrandEntity, fetchBrandProductsUseCase: FetchBrandProductsUseCaseProtocol) {
        self.brand = brand
        self.fetchBrandProductsUseCase = fetchBrandProductsUseCase
    }

    var categories: [CategoryEntity] {
        [
            CategoryEntity(id: "all", name: "All"),
            CategoryEntity(id: "tshirts", name: "T-Shirts"),
            CategoryEntity(id: "shoes", name: "Shoes"),
            CategoryEntity(id: "accessories", name: "Accessories")
        ]
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
            switch selectedCategory.id {
            case "tshirts":
                return name.contains("shirt") || name.contains("t-shirt") || name.contains("tee")
            case "shoes":
                return name.contains("shoe") || name.contains("sneaker") || name.contains("boot")
            case "accessories":
                return name.contains("accessor") || name.contains("hat") || name.contains("bag") || name.contains("belt")
            default:
                return name.contains(selectedCategory.name.lowercased())
            }
        }
    }

    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        do {
            
            products = try await fetchBrandProductsUseCase.execute(vendorName: brand.name)
        } catch {
            #if DEBUG
            print("FetchBrandProductsUseCase failed for \(brand.name): \(error)")
            #endif
            errorMessage = "Couldn't load products. Pull to refresh."
        }
        isLoading = false
    }

    func select(_ category: CategoryEntity) {
        selectedCategory = category
    }
}
