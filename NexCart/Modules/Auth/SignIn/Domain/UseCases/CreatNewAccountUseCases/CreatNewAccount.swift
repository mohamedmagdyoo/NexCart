//
//  CreatNewAccount.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

protocol CreatNewAccountUseCaseProtocol: AnyObject{
    func excute(signUpCredentials: SignUpCredentials) async throws -> UserEntity
}


final class CreatNewAccountUseCase: CreatNewAccountUseCaseProtocol{
    private var authRepo: AuthRepositoryProtocol
    
    init(authRepo: AuthRepositoryProtocol) {
        self.authRepo = authRepo
    }
    
    func excute(signUpCredentials: SignUpCredentials) async throws -> UserEntity {
        try await authRepo.createAccount(with: signUpCredentials)
    }
}
