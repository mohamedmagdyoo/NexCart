//
//  LoginWithSocialProviderUseCase.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

protocol LoginWithSocialProviderUseCaseProtocol: AnyObject{
    func excute(socialProvider: SocialAuthProvider) async throws -> UserEntity
}


final class LoginWithSocialProvider: LoginWithSocialProviderUseCaseProtocol{
    private var authRepo: AuthRepositoryProtocol
    private let productsRepository: ProductsRepoProtocol

    init(authRepo: AuthRepositoryProtocol, productsRepository: ProductsRepoProtocol) {
        self.authRepo = authRepo
        self.productsRepository = productsRepository
    }
    
    func excute(socialProvider: SocialAuthProvider) async throws -> UserEntity {
        let userEntity = try await authRepo.loginWithSocialProvider(socialProvider)
        try await productsRepository.syncData(userId: userEntity.id)
        return userEntity
    }
}
