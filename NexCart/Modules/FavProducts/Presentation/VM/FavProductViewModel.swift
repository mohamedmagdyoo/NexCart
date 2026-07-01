//
//  FavProductViewModel.swift
//  NexCart
//
//  Created by Mohamed Magdy on 30/06/2026.
//

import Foundation

enum FavProductsScreenStates {
    case succes
    case loading
    case empty
}


@MainActor
final class FavProductsViewModel: ObservableObject {
    @Published var favProducts: [FavProduct] = [FavProduct]()
    @Published var screenStates: FavProductsScreenStates = .loading
    @Published var alert: AlertModel?

    // MARK: - UseCases
    private let fetchFavProductsUseCase: FetchFavProductsUseCaseProtocol
    private let removeFavProductUseCase: RemoveFavProductUseCaseProtocol

    init(
        fetchFavProductsUseCase: FetchFavProductsUseCaseProtocol,
        removeFavProductUseCase: RemoveFavProductUseCaseProtocol
    ) {
        
        self.fetchFavProductsUseCase = fetchFavProductsUseCase
        self.removeFavProductUseCase = removeFavProductUseCase
    }

    func onAppear() {
        loadFavProducts()
    }

    func loadFavProducts() {
        screenStates = .loading
        do {
            let products = try fetchFavProductsUseCase.execute()
            favProducts = products
            screenStates = products.isEmpty ? .empty : .succes
        } catch {
            favProducts = []
            screenStates = .empty
            alert = AlertModel(
                title: "Couldn't Load Favorites",
                description: error.localizedDescription
            )
        }
    }

    func removeFromFav(_ product: FavProduct) {
        // Optimistic update so the "x" feels instant; rolled back on failure.
        let previousProducts = favProducts
        let previousState = screenStates

        favProducts.removeAll { $0.id == product.id }
        screenStates = favProducts.isEmpty ? .empty : .succes

        do {
            try removeFavProductUseCase.execute(productId: product.id)
        } catch {
            favProducts = previousProducts
            screenStates = previousState
            alert = AlertModel(
                title: "Couldn't Remove Item",
                description: error.localizedDescription
            )
        }
    }
}
