//
//  ProductViewModelPorotocl.swift
//  Shopify
//
//  Created by Antoneos Philip on 27/06/2026.
//

import Foundation

protocol ProductDetailsViewModelProtocol: ObservableObject {
//    var product: Product? { get set }
//    func setProduct(_ product: Product)
    func addToCart(
        variantID: Int,
        customerID: Int,
        quantity: Int
    ) async 
    
}
