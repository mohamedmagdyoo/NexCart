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
        
    }
}

