//
//  ProductDetailsViewModel.swift
//  NexCart
//
//  Created by Mohamed Magdy on 01/07/2026.
//

import Foundation

@MainActor
class ProductDetailViewModel: ObservableObject {

    @Published var product: ProductDTO?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init(product: ProductDTO? = nil) {
        self.product = product
    }

    func loadProductDetails(productId: Int) async {
        guard product == nil else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await Task.sleep(nanoseconds: 2_000_000_000)
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func setProduct(_ product: ProductDTO) {
        self.product = product
    }
}
