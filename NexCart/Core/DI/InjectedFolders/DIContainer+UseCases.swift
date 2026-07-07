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
            LoginWithEmailUseCase(repository: r.resolve(AuthRepositoryProtocol.self)!,
                                  productsRepository: r.resolve(ProductsRepoProtocol.self)!)
        }
        
        container.register(LoginWithSocialProviderUseCaseProtocol.self) { r in
            LoginWithSocialProvider(authRepo: r.resolve(AuthRepositoryProtocol.self)!,productsRepository: r.resolve(ProductsRepoProtocol.self)!)
        }
        
        container.register(LoginAsGuestUseCaseProtocol.self) { r in
            LoginAsGuestUseCase(authRepo: r.resolve(AuthRepositoryProtocol.self)!,productsRepository: r.resolve(ProductsRepoProtocol.self)!)
        }
        
        container.register(CreatNewAccountUseCaseProtocol.self) { r in
            CreatNewAccountUseCase(authRepo: r.resolve(AuthRepositoryProtocol.self)!,productsRepository: r.resolve(ProductsRepoProtocol.self)!)
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
        //SearchUseCase
        container.register(SearchUseCaseProtocol.self) { r in
            SearchUseCase(repo: r.resolve(SearchRepoProtocol.self)!)
        }
        
        //FavUseCases
        container.register(FetchFavProductsUseCaseProtocol.self){ r in
            FetchFavProducts(repo: r.resolve(ProductsRepoProtocol.self)!)
        }
        
        container.register(RemoveFavProductUseCaseProtocol.self){ r in
            RemoveFavProduct(repo: r.resolve(ProductsRepoProtocol.self)!)
        }
        container.register(FetchCollectionsUseCaseProtocol.self) { r in
            FetchCollectionsUseCase(repo: r.resolve(CollectionsRepoProtocol.self)!)
        }
        
        container.register(FetchCollectionProductsUseCaseProtocol.self) { r in
            FetchCollectionProductsUseCase(repo: r.resolve(CollectionsRepoProtocol.self)!)
        }
        
        container.register(AddCartUseCase.self) { r in
            AddCartUseCase(
                productDetailsRepo: r.resolve(ProductDetailsRepo.self)!
            )
        }
        
        container.register(CartUseCaseProtocol.self){
            r in
            CartUseCase(cartRepo: r.resolve(CartRepoProtcol.self)!)
        }
        
        
        // Coupon
        container.register(ApplyCouponUseCaseProtocol.self) { r in
            ApplyCouponUseCase(repository: r.resolve(CouponRepository.self)!)
        }
        container.register(FetchProductByIDUseCaseProtocol.self) { r in
            FetchProductByIdUseCase(repo: r.resolve(ProductsRepoProtocol.self)!)
        }
        
        //For Address
        container.register(AddAddressUseCase.self) { r in
            AddAddressUseCase(repository: r.resolve(AddressRepository.self)!)
        }
        container.register(DeleteAddressUseCase.self) { r in
            DeleteAddressUseCase(repository: r.resolve(AddressRepository.self)!)
        }
        container.register(DeleteAllAddressesUseCase.self) { r in
            DeleteAllAddressesUseCase(repository: r.resolve(AddressRepository.self)!)
        }
        container.register(GetAllAddressesUseCase.self) { r in
            GetAllAddressesUseCase(repository: r.resolve(AddressRepository.self)!)
        }
        container.register(GetDefaultAddressUseCase.self) { r in
            GetDefaultAddressUseCase(repository: r.resolve(AddressRepository.self)!)
        }
        //orderList
        container.register(FetchOrdersUseCaseProtocol.self) { r in
            FetchOrdersUseCase(repo: r.resolve(OrderRepoProtocol.self)!)
            
        }
        //For Payment
        container.register(SelectAddressUseCaseProtocol.self) { r in
            SelectAddressUseCase(addressRepository: r.resolve(AddressRepository.self)!)
        }
        
        //For Payment
        container.register(GetPaymentMethodsUseCaseProtocol.self) { _ in
            GetPaymentMethodsUseCase()
        }
        
        //For Payment
        container.register(SelectPaymentMethodUseCaseProtocol.self) { _ in
            SelectPaymentMethodUseCase()
        }
        
        container.register(ProcessPaymentWithApplePayUseCase.self) { r in
            ProcessPaymentWithApplePayUseCase(paymentRepository: r.resolve(PaymentRepositoryProtocol.self)!)
        }
        
        container.register(CompleteOrderUseCaseProtocol.self) { r in
            CompleteOrderUseCase(repository:  r.resolve(CompleteOrderRepositoryProtocol.self)!)
        }

        //For ai
        container.register(AddProductToSelectionUseCaseProtocol.self) { r in
            AddProductToSelectionUseCase(
                repository: r.resolve(OutfitSelectionRepositoryProtocol.self)!
            )
        }

        container.register(RemoveProductFromSelectionUseCaseProtocol.self) { r in
            RemoveProductFromSelectionUseCase(
                repository: r.resolve(OutfitSelectionRepositoryProtocol.self)!
            )
        }

        container.register(GetSelectedProductsUseCaseProtocol.self) { r in
            GetSelectedProductsUseCase(
                repository: r.resolve(OutfitSelectionRepositoryProtocol.self)!
            )
        }
        
        //ai
        container.register(GenerateOutfitUseCaseProtocol.self) { r in
            GenerateOutfitUseCase(
                repository: r.resolve(AIOutfitRepositoryProtocol.self)!
            )
        }
        
        //saved
        container.register(SaveGeneratedOutfitUseCaseProtocol.self) { r in
            SaveGeneratedOutfitUseCase(
                repository: r.resolve(SavedOutfitRepositoryProtocol.self)!
            )
        }

        container.register(GetSavedOutfitsUseCaseProtocol.self) { r in
            GetSavedOutfitsUseCase(
                repository: r.resolve(SavedOutfitRepositoryProtocol.self)!
            )
        }

        container.register(DeleteSavedOutfitUseCaseProtocol.self) { r in
            DeleteSavedOutfitUseCase(
                repository: r.resolve(SavedOutfitRepositoryProtocol.self)!
            )
        }
    }
}
