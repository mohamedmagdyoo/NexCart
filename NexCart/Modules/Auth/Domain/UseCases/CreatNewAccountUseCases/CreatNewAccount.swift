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
    
    init(authRepo: AuthRepositoryProtocol) {
        self.authRepo = authRepo
    }
    
    func excute(credentials: SignUpCredentials) async throws -> UserEntity {
        if credentials.email.isEmpty || !credentials.email.contains("@") {
            throw AuthError.invalidEmail
        }
        if credentials.password.count < 8 {
            throw AuthError.weakPassword
        }
        return try await authRepo.createAccount(with: credentials)
    }
}
