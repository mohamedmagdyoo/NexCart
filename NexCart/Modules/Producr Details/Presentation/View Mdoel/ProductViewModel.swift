//
//  ProductViewModel.swift
//  Shopify
//
//  Created by Antoneos Philip on 27/06/2026.
//

import Foundation
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
