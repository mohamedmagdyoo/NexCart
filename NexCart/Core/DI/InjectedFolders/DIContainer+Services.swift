//
//  DIContainer+Services.swift
//  NexCart
//
//  Created by Mohamed Magdy on 29/06/2026.
//

import Foundation
import Swinject

extension DIContainer{
    func registerServices(){
        //FirBaseAutheServise
        container.register(FirebaseAuthService.self){ _ in
            FirebaseAuthService()
        }
        container.register(ApiServiceProtocol.self){ _ in
            ApiService()
        }.inObjectScope(.container)
        
        //FavProductsDao
        container.register(FavProductsDAO.self){ _ in
            FavProductsDAO()
        }
        container.register(AuthShopifyServiceProtocol.self){ _ in
            AuthShopifyService()
        }
        
        container.register(ProductDetailsService.self) { r in
            ProductDetailsService(
                networkClient: r.resolve(ApiServiceProtocol.self)!
            )
        }
        
        //FavProductsRemoteServiceProtocol
        container.register(FavProductsRemoteServiceProtocol.self){_ in
            FavProductsFirestoreService()
        }
        
        container.register(ProductRemoteDataSource.self) { r in
                  ProductRemoteDataSource(apiService: r.resolve(ApiServiceProtocol.self)!)
              }.inObjectScope(.container)
        //For Address
        container.register(AddressDao.self){ _ in
            CoreDataAddressDao()
        }
        container.register(OrderRemoteDataSourceProtocol.self) { r in
            OrderRemoteDataSource(apiService: r.resolve(ApiServiceProtocol.self)!)
        }.inObjectScope(.container)
        
        //For Payment
        container.register(ApplePayServiceProtocol.self){ _ in
            ApplePayService()
        }
        
        container.register(CreateOrderServiceProtocol.self) { r in
            CreateOrderServiceImpl(apiService: r.resolve(ApiServiceProtocol.self)!)
        }
        
        //For AiFeature
        container.register(GeneratedOutfitDAOProtocol.self) { _ in
            GeneratedOutfitDAO()
        }

        container.register(SelectedProductDAOProtocol.self) { _ in
            SelectedProductDAO()
        }
        
        container.register(HuggingFaceServiceProtocol.self) { _ in
            HuggingFaceService()
        }

        container.register(HuggingFaceProvider.self) { r in
            HuggingFaceProvider(
                service: HuggingFaceService(),
                imageDownloadService: ImageDownloadService(),
                imageCompositionService: ImageCompositionService()
            )
        }
    }
}
