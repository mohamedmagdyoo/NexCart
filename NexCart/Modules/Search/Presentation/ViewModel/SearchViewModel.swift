//
//  SearchViewModel.swift
//  NexCart
//
//  Created by shady ramadan on 03/07/2026.
//

import Foundation
 
@MainActor
final class SearchViewModel: ObservableObject {
 
    @Published var query:          String         = ""
    @Published var brandResults:   [BrandResult]  = []
    @Published var productResults: [ProductEntity] = []  
 
    struct BrandResult: Identifiable {
        let id:       String
        let name:     String
        let imageURL: String
        let count:    Int
    }
 
    var isIdle:   Bool { query.trimmingCharacters(in: .whitespaces).isEmpty }
    var hasResults: Bool { !brandResults.isEmpty || !productResults.isEmpty }
 
    private let sourceProducts: [ProductEntity]
    private var searchTask: Task<Void, Never>?
    private let coreDataService = CoreDataService.shared
 
    init(sourceProducts: [ProductEntity]) {
        self.sourceProducts = sourceProducts
    }
 
    func onQueryChanged() {
        searchTask?.cancel()
 
        let q = query.trimmingCharacters(in: .whitespaces).lowercased()
        guard !q.isEmpty else {
            brandResults   = []
            productResults = []
            return
        }
 
        filterLocally(query: q)
    }
 
    func clearSearch() {
        query          = ""
        brandResults   = []
        productResults = []
        searchTask?.cancel()
    }
 
    func toggleFavorite(productId: Int) {
        guard let i = productResults.firstIndex(where: { $0.id == productId }) else { return }
        productResults[i].isFavorited.toggle()
        if productResults[i].isFavorited {
            coreDataService.saveProductToDatabase(product: productResults[i])
        } else {
            coreDataService.deleteProductFromDatabase(id: productResults[i].id)
        }
    }
 
    private func filterLocally(query q: String) {
        productResults = sourceProducts.filter {
            $0.name.lowercased().contains(q)
        }
 
        var seen  = Set<String>()
        var brands = [BrandResult]()
 
        for product in sourceProducts {
            let brandLower = product.brand.lowercased()
            guard brandLower.contains(q), seen.insert(product.brand).inserted else { continue }
 
            let brandProducts = sourceProducts.filter { $0.brand == product.brand }
            brands.append(BrandResult(
                id:       product.brand,
                name:     product.brand,
                imageURL: brandProducts.first?.imageURL ?? "",
                count:    brandProducts.count
            ))
        }
        brandResults = brands
    }
}
 
