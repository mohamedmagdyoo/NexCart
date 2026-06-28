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

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func execute(credentials: EmailCredentials) async throws -> UserEntity {
        
        if credentials.email.isEmpty || !credentials.email.contains("@") {
            throw AuthError.invalidEmail
        }
        if credentials.password.count < 6 {
            throw AuthError.weakPassword
        }
        return try await repository.loginWithEmail(credentials)
    }
}
