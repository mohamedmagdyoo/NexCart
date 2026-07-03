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
        }.inObjectScope(.container) // to make it singltone
        
        
        container.register(HomeRepoProtocol.self) { r in
            HomeRepository(apiService: r.resolve(ApiServiceProtocol.self)!)
        }.inObjectScope(.container)
        
        container.register(BrandsRepoProtocol.self) { r in
            BrandsRepository(apiService: r.resolve(ApiServiceProtocol.self)!)
        }.inObjectScope(.container)
        container.register(CollectionsRepoProtocol.self) { r in
                    CollectionsRepository(apiService: r.resolve(ApiServiceProtocol.self)!)
                }.inObjectScope(.container)
        //Prouducts Repo
        container.register(ProductsRepoProtocol.self){ r in
            ProductsRepo(favProductReopo: r.resolve(FavProductRepoInterface.self)!)
        }
        
        //FavProductsRepo
        container.register(FavProductRepoInterface.self){ r in
            FavProductsRepository(localDao: r.resolve(FavProductsDAO.self)!, remoteService: r.resolve(FavProductsRemoteServiceProtocol.self)!)
        }
        
        container.register(ProductDetailsRepo.self) { r in
            ProductDetailRepoImpl(
                productDetailsService: r.resolve(ProductDetailsService.self)!
            )
        }

        
        container.register(CartRepoProtcol.self) { r in
            CartRepo(
                apiService: r.resolve(ApiServiceProtocol.self)!
            )
        }

        // Coupone
        container.register(GraphQLServiceProtocol.self) { _ in
            ShopifyGraphQLService(
                baseURL: URL(string: "https://mad46-ios-team9.myshopify.com/admin/api/2026-01/")!,
                accessToken: "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"
            )
        }.inObjectScope(.container)

        container.register(CouponRemoteDataSource.self) { r in
            ShopifyCouponGraphQLDataSource(graphQLService: r.resolve(GraphQLServiceProtocol.self)!)
        }.inObjectScope(.container)

        container.register(CouponRepository.self) { r in
            CouponRepositoryImpl(remoteDataSource: r.resolve(CouponRemoteDataSource.self)!)
        }.inObjectScope(.container)

    }
}
