//
//  LoginWithEmailUseCase.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

protocol LoginWithEmailUseCaseProtocol: AnyObject {
    func execute(credentials: EmailCredentials) async throws -> UserEntity
}


final class LoginWithEmailUseCase: LoginWithEmailUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    private let productsRepository: ProductsRepoProtocol

    init(repository: AuthRepositoryProtocol, productsRepository: ProductsRepoProtocol) {
        self.repository = repository
        self.productsRepository = productsRepository
    }

    func execute(credentials: EmailCredentials) async throws -> UserEntity {
        
        if credentials.email.isEmpty || !credentials.email.contains("@") {
            throw AuthError.invalidEmail
        }
        if credentials.password.count < 8 {
            throw AuthError.weakPassword
        }
        
        //sycnData
        try await productsRepository.syncData()
        
        return try await repository.loginWithEmail(credentials)
    }
}
