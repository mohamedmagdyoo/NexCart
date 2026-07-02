//
//  CartViewModel.swift
//  NexCart
//
//  Created by Antoneos Philip on 01/07/2026.
//

import Foundation
enum CartState{
    case success(bagData:[BagEntity])
    case loading
    case error(message:String)
    
}

class CartViewModel : CartViewModelProtocol,ObservableObject{
    @Published var cartState:CartState = .loading
    @Published var cartData:[BagItemEntity] = []
    
    private let cartUseCase:CartUseCaseProtocol
    
    init(cartUseCase: CartUseCaseProtocol) {
        self.cartUseCase = cartUseCase
    }
    func getAllCart() async  {
        cartState = .loading
        do{
            cartData = try await cartUseCase.getAllCart()
            cartState = .success(bagData: cartData)
        }
        catch {
            cartState = .error(message: "Failed to load cart")
        }
    }
}
