//
//  DIContainer+Repositories.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation
import Swinject
 
extension DIContainer {
    func registerRepositories() {
        container.register(AuthRepositoryProtocol.self) { r in
            AuthRepository(service: r.resolve(FirebaseAuthService.self)!,
                           shopifyService: r.resolve(AuthShopifyServiceProtocol.self)!)
        }.inObjectScope(.container)
 
        container.register(HomeRepoProtocol.self) { r in
            HomeRepository(apiService: r.resolve(ApiServiceProtocol.self)!)
        }.inObjectScope(.container)
 
        container.register(BrandsRepoProtocol.self) { r in
            BrandsRepository(apiService: r.resolve(ApiServiceProtocol.self)!)
        }.inObjectScope(.container)
 
        container.register(CollectionsRepoProtocol.self) { r in
            CollectionsRepository(apiService: r.resolve(ApiServiceProtocol.self)!)
        }.inObjectScope(.container)
 
        // Search
        container.register(SearchRepoProtocol.self) { r in
            SearchRepository(apiService: r.resolve(ApiServiceProtocol.self)!)
        }.inObjectScope(.container)
 
        // Products Repo
        container.register(ProductsRepoProtocol.self) { r in
            ProductsRepo(favProductReopo: r.resolve(FavProductRepoInterface.self)!)
        }
 
        // FavProducts Repo
        container.register(FavProductRepoInterface.self) { r in
            FavProductsRepository(
                localDao: r.resolve(FavProductsDAO.self)!,
                remoteService: r.resolve(FavProductsRemoteServiceProtocol.self)!
            )
        }
 
        container.register(ProductDetailsRepo.self) { r in
            ProductDetailRepoImpl(
                productDetailsService: r.resolve(ProductDetailsService.self)!
            )
        }
    }
}
