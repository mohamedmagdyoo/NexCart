//
//  CreatNewAccount.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

protocol CreatNewAccountUseCaseProtocol: AnyObject{
    func excute(credentials: SignUpCredentials) async throws -> UserEntity
}


final class CreatNewAccountUseCase: CreatNewAccountUseCaseProtocol{
    private var authRepo: AuthRepositoryProtocol
    private let productsRepository: ProductsRepoProtocol

    init(authRepo: AuthRepositoryProtocol, productsRepository: ProductsRepoProtocol) {
        self.authRepo = authRepo
        self.productsRepository = productsRepository
    }
    
    func excute(credentials: SignUpCredentials) async throws -> UserEntity {
        if credentials.email.isEmpty || !credentials.email.contains("@") {
            throw AuthError.invalidEmail
        }
        if credentials.password.count < 8 {
            throw AuthError.weakPassword
        }
        
        if credentials.password != credentials.passwordConfirmation{
            throw AuthError.passwordsDidNotMatchConfirmedPass
        }
        
        if credentials.phone!.prefix(2) != "+2"{
            throw AuthError.wrongStartWithPhoneNumber
        }
        
        productsRepository.cleanFavTabel()
        return try await authRepo.createAccount(with: credentials)
    }
}
