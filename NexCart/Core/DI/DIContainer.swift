//
//  DIContainer.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

import Swinject

@MainActor
final class DIContainer {
    static let shared = DIContainer()
    let container = Container()

    private init() {
        registerAll()
    }

    private func registerAll() {
        registerServices()
        registerRepositories()
        registerUseCases()
        registerViewModels()
    }
}


/**
 
 container.register(ApiServiceProtocol.self) { _ in ApiService() }
     .inObjectScope(.container)

 container.register(ApplePayServiceProtocol.self) { _ in ApplePayService() }
     .inObjectScope(.container)

 container.register(ShopifyOrderServiceProtocol.self) { r in
     ShopifyOrderService(apiService: r.resolve(ApiServiceProtocol.self)!)
 }.inObjectScope(.container)

 container.register(CheckoutRepositoryProtocol.self) { r in
     CheckoutRepositoryImpl(
         applePayService: r.resolve(ApplePayServiceProtocol.self)!,
         shopifyOrderService: r.resolve(ShopifyOrderServiceProtocol.self)!,
         merchantIdentifier: "merchant.com.yourteam.nexcart"
     )
 }.inObjectScope(.container)
 
 */
