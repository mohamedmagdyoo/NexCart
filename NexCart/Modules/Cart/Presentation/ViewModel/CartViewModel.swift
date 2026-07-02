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
    @Published var cartData:[BagEntity] = []
    private let currentCustomerId = 10880560562482
    private let cartUseCase:CartUseCaseProtocol
    @Published var images: [Int: String] = [:]
    init(cartUseCase: CartUseCaseProtocol) {
        self.cartUseCase = cartUseCase
    }
    func getAllCart() async  {
        cartState = .loading
        do{
            let allCarts = try await cartUseCase.getAllCart()
            cartData = allCarts.filter { $0.customer?.id == currentCustomerId }
           try await getSingleProdut()
            cartState = .success(bagData: cartData)
        }
        catch {
            cartState = .error(message: "Failed to load cart")
        }
    }
    
    
    func getSingleProdut() async {
        do{
            for item in cartData {
                let product = try await cartUseCase.getSingleProduct(productId: item.items.first?.productId ?? 0)
                print("imageeee \(product.imageURL)")
                images[product.id]=product.imageURL
                }
        }
        catch {
            print("errorrr \(error)")
            cartState = .error(message: "Failed to load product")
        }
    }
    
}
