//
//  ProductViewModel.swift
//  Shopify
//
//  Created by Antoneos Philip on 27/06/2026.
//

import Foundation
enum ProductDetailScreenState {
    case idle
    case loading
    case success
    case error(data:any Error)
}


@MainActor
final class ProductDetailViewModel: ObservableObject, ProductDetailsViewModelProtocol {

    private let addCartUseCase: AddCartUseCase
    private let coreDataService = CoreDataService.shared
    @Published var screenState: ProductDetailScreenState = .idle

    init(addCartUseCase: AddCartUseCase) {
        self.addCartUseCase = addCartUseCase
    }

    func toggleFavorite(product: ProductEntity) {
        if product.isFavorited {
            coreDataService.saveProductToDatabase(product: product)
        } else {
            coreDataService.deleteProductFromDatabase(id: product.id)
        }
    }

    func addToCart(
        variantID: Int,
        customerID: Int,
        quantity: Int
    ) async {

        screenState = .loading

        do {
            let _ = try await addCartUseCase.addToCart(
                variantID: variantID,
                customerID: customerID,
                quantity: quantity
            )

            screenState = .success

        } catch {
            print("erorrr \(error)")
            screenState = .error(data: error)
        }
    }
}
