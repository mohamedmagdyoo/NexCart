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
    @Published var isLoadingProduct: Bool = false
    @Published var favProducts: [FavProduct] = [FavProduct]()
    @Published var screenStates: FavProductsScreenStates = .loading
    @Published var alert: AlertModel?
    @Published var selectedProductToRemove: FavProduct?
    @Published var showRemoveAlert: Bool = false
    

    // MARK: - UseCases
    private let fetchFavProductsUseCase: FetchFavProductsUseCaseProtocol
    private let removeFavProductUseCase: RemoveFavProductUseCaseProtocol
    private let fetchProductByIdUseCase: FetchProductByIDUseCaseProtocol

    init(
        fetchFavProductsUseCase: FetchFavProductsUseCaseProtocol,
        removeFavProductUseCase: RemoveFavProductUseCaseProtocol,
        fetchProductByIdUseCase:
            FetchProductByIDUseCaseProtocol
    ) {
        
        self.fetchFavProductsUseCase = fetchFavProductsUseCase
        self.removeFavProductUseCase = removeFavProductUseCase
        self.fetchProductByIdUseCase = fetchProductByIdUseCase
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
    func fetchAndNavigate(to product: FavProduct) async -> ProductEntity? {
        isLoadingProduct = true
        defer { isLoadingProduct = false }
        do {
            return try await fetchProductByIdUseCase.execute(productID: product.id)
        } catch {
            alert = AlertModel(
                title: "Couldn't Load Product",
                description: error.localizedDescription
            )
            return nil
        }
    }
    func didTapToDelete(product: FavProduct){
        selectedProductToRemove = product
        showRemoveAlert = true
    }
    
    func confirmRemoveProduct(){
        removeFromFav(selectedProductToRemove!)
    }

    func removeFromFav(_ product: FavProduct) {
        let previousProducts = favProducts
        let previousState = screenStates

        favProducts.removeAll { $0.id == product.id }
        screenStates = favProducts.isEmpty ? .empty : .succes

        do {
            Task{
                try await removeFavProductUseCase.execute(productId: product.id)
            }
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
