//
//  LoginAsGuestUseCase.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

protocol LoginAsGuestUseCaseProtocol: AnyObject{
    func excute() -> UserEntity
}


final class LoginAsGuestUseCase: LoginAsGuestUseCaseProtocol{
    private var authRepo: AuthRepositoryProtocol
    
    init(authRepo: AuthRepositoryProtocol) {
        self.authRepo = authRepo
    }
    
    func excute() -> UserEntity {
        authRepo.continueAsGuest()
    }
}

