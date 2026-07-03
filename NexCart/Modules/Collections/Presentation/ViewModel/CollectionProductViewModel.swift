//
//  CollectionProductViewModel.swift
//  NexCart
//
//  Created by shady ramadan on 02/07/2026.
//

import Foundation

enum PriceRange: String, CaseIterable, Identifiable {
    case all       = "All"
    case under50   = "Under $50"
    case r50to100  = "$50 - $100"
    case r100to200 = "$100 - $200"
    case over200   = "Over $200"

    var id: String { rawValue }

    func contains(_ price: Double) -> Bool {
        switch self {
        case .all:       return true
        case .under50:   return price < 50
        case .r50to100:  return price >= 50 && price <= 100
        case .r100to200: return price > 100 && price <= 200
        case .over200:   return price > 200
        }
    }
}

@MainActor
final class CollectionProductsViewModel: ObservableObject {
 
    @Published var products: [ProductEntity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var selectedBrand: String = "All"
    @Published var selectedType: String = "All"
    @Published var selectedPriceRange: PriceRange = .all
 
    let collection: CustomCollectionEntity
    private let fetchCollectionProductsUseCase: FetchCollectionProductsUseCaseProtocol
    private let coreDataService = CoreDataService.shared
 
    init(collection: CustomCollectionEntity, fetchCollectionProductsUseCase: FetchCollectionProductsUseCaseProtocol) {
        self.collection = collection
        self.fetchCollectionProductsUseCase = fetchCollectionProductsUseCase
    }

    var availableBrands: [String] {
        let names = Set(products.map { $0.brand }).filter { !$0.isEmpty }
        return ["All"] + names.sorted()
    }

    var availableTypes: [String] {
        let names = Set(products.map { $0.productType }).filter { !$0.isEmpty }
        return ["All"] + names.sorted()
    }

    var availablePriceRanges: [PriceRange] {
        PriceRange.allCases
    }

    var filteredProducts: [ProductEntity] {
        products.filter { product in
            (selectedBrand == "All" || product.brand == selectedBrand) &&
            (selectedType == "All" || product.productType == selectedType) &&
            selectedPriceRange.contains(product.price)
        }
    }

    var isFilterActive: Bool {
        selectedBrand != "All" || selectedType != "All" || selectedPriceRange != .all
    }

    func selectBrand(_ brand: String) {
        selectedBrand = brand
    }

    func selectType(_ type: String) {
        selectedType = type
    }
 
    func toggleFavorite(productId: Int) {
        guard let index = products.firstIndex(where: { $0.id == productId }) else { return }
        products[index].isFavorited.toggle()
 
        let product = products[index]
        if product.isFavorited {
            coreDataService.saveProductToDatabase(product: product)
        } else {
            coreDataService.deleteProductFromDatabase(id: product.id)
        }
    }
 
    func loadProducts() async {
        isLoading = true
        errorMessage = nil
        do {
            var fetchedProducts = try await fetchCollectionProductsUseCase.execute(collectionId: collection.id)
 
            for i in fetchedProducts.indices {
                fetchedProducts[i].isFavorited = coreDataService.isFavorite(id: fetchedProducts[i].id)
            }
 
            products = fetchedProducts
        } catch {
            #if DEBUG
            print("FetchCollectionProductsUseCase failed for \(collection.title): \(error)")
            #endif
            errorMessage = "Couldn't load products. Pull to refresh."
        }
        isLoading = false
    }
}
