//
//  DIContainer+UseCases.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

import Swinject

extension DIContainer {
    func registerUseCases() {
        container.register(LoginWithEmailUseCaseProtocol.self) { r in
            LoginWithEmailUseCase(repository: r.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(LoginWithSocialProviderUseCaseProtocol.self) { r in
            LoginWithSocialProvider(authRepo: r.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(LoginAsGuestUseCaseProtocol.self) { r in
            LoginAsGuestUseCase(authRepo: r.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(CreatNewAccountUseCaseProtocol.self) { r in
            CreatNewAccountUseCase(authRepo: r.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(LogOutUseCaseProtocol.self) { r in
            LogOutUseCase(authRepo: r.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(ForgotPassUseCaseProtocol.self) { r in
            ForgotPassUseCase(authRepo: r.resolve(AuthRepositoryProtocol.self)!)
        }
        
        container.register(FetchHomeProductsUseCaseProtocol.self) { r in
            FetchHomeProductsUseCase(repo: r.resolve(HomeRepoProtocol.self)!)
        }
       
        container.register(FetchHomeBrandsUseCaseProtocol.self) { r in
            FetchHomeBrandsUseCase(repo: r.resolve(HomeRepoProtocol.self)!)
        }
       
        container.register(FetchHeroSlidesUseCaseProtocol.self) { _ in
            FetchHeroSlidesUseCase()
        }
        
        container.register(FetchBrandsUseCaseProtocol.self) { r in
            FetchBrandsUseCase(repo: r.resolve(BrandsRepoProtocol.self)!)
        }
         
        container.register(FetchBrandProductsUseCaseProtocol.self) { r in
            FetchBrandProductsUseCase(repo: r.resolve(BrandsRepoProtocol.self)!)
        }
        
        //FavUseCases
//        container.register(FetchFavProductsUseCaseProtocol.self){ r in
//            FetchFavProducts(repo: r.resolve(ProductsRepoProtocol.self)!)
//        }
//
//        container.register(RemoveFavProductUseCaseProtocol.self){ r in
//            RemoveFavProduct(repo: r.resolve(ProductsRepoProtocol.self)!)
//        }
    }
}
