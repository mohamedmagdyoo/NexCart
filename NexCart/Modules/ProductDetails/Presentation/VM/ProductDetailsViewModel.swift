//
//  ProductDetailsViewModel.swift
//  NexCart
//
//  Created by Mohamed Magdy on 01/07/2026.
//

import Foundation

@MainActor
class ProductDetailViewModel {

    @Published var product: Product?

    init(product: Product) {
        self.product = product
    }

    func setProduct(_ product: Product) {
        self.product = product
    }
}
