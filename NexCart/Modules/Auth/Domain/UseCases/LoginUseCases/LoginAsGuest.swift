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
    private let productsRepository: ProductsRepoProtocol

    
    init(authRepo: AuthRepositoryProtocol, productsRepository: ProductsRepoProtocol) {
        self.authRepo = authRepo
        self.productsRepository = productsRepository
    }
    
    func excute() -> UserEntity {
        productsRepository.cleanFavTabel()
        return authRepo.continueAsGuest()
    }
}

