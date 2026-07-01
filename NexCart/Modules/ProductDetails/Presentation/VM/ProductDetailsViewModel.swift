//
//  ProductDetailsViewModel.swift
//  NexCart
//
//  Created by Mohamed Magdy on 01/07/2026.
//

import Foundation

import Foundation

@MainActor
class ProductDetailViewModel: ObservableObject {

    @Published var product: ProductDTO?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private let repository: ProductRepositoryProtocol

    init(product: ProductDTO? = nil, repository: ProductRepositoryProtocol = ProductRepository()) {
        self.product = product
        self.repository = repository
    }

    func loadProductDetails(productId: Int) async {
        guard product == nil else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
        let fetchedProduct = try await repository.fetchProductDetails(productId: productId)
            self.product = fetchedProduct
        } catch {
            self.errorMessage = error.localizedDescription
          
        }
    }

    func setProduct(_ product: ProductDTO) {
        self.product = product
    }
}
