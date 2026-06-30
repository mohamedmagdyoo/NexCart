//
//  DIContainer+ViewModels.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation
import Swinject

@MainActor
extension DIContainer {
    func registerViewModels() {
        //SingIn
        container.register(SignInViewModel.self) { r in
            SignInViewModel(
                loginWithEmailPassUC: r.resolve(LoginWithEmailUseCaseProtocol.self)!,
                loginWithProviderUC: r.resolve(LoginWithSocialProviderUseCaseProtocol.self)!,
                loginAsGuestUC: r.resolve(LoginAsGuestUseCaseProtocol.self)!
            )
        }
        
        //SginUp
        container.register(SignUpViewModel.self) { r in
            SignUpViewModel(signUpUseCase: r.resolve(CreatNewAccountUseCaseProtocol.self)!, loginWithProviderUC: r.resolve(LoginWithSocialProviderUseCaseProtocol.self)!)
        }
        
        //Home
        container.register(HomeViewModel.self) { r in
            HomeViewModel(
                fetchProductsUseCase: r.resolve(FetchHomeProductsUseCaseProtocol.self)!,
                fetchBrandsUseCase: r.resolve(FetchHomeBrandsUseCaseProtocol.self)!,
                fetchSlidesUseCase: r.resolve(FetchHeroSlidesUseCaseProtocol.self)!
            )
        }
        
        //Fav
        container.register(FavProductsViewModel.self){ r in
            FavProductsViewModel(fetchFavProductsUseCase: r.resolve(FetchFavProductsUseCaseProtocol.self)!, removeFavProductUseCase: r.resolve(RemoveFavProductUseCaseProtocol.self)!)
        }
        
    }
}

