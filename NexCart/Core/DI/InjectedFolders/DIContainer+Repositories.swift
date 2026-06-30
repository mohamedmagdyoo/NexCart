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
            FirebaseAuthRepository(service: r.resolve(FirebaseAuthService.self)!)
        }.inObjectScope(.container) // to make it singltone
        
        
        container.register(HomeRepoProtocol.self) { r in
            HomeRepository(apiService: r.resolve(ApiServiceProtocol.self)!)
        }.inObjectScope(.container)
        
        container.register(BrandsRepoProtocol.self) { r in
            BrandsRepository(apiService: r.resolve(ApiServiceProtocol.self)!)
        }.inObjectScope(.container)
        
        //Prouducts Repo
        container.register(ProductsRepoProtocol.self){ _ in
            ProductsRepo()
        }
    }
}
