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
    
    init(authRepo: AuthRepositoryProtocol) {
        self.authRepo = authRepo
    }
    
    func excute(socialProvider: SocialAuthProvider) async throws -> UserEntity {
        try await authRepo.loginWithSocialProvider(socialProvider)
    }
}
