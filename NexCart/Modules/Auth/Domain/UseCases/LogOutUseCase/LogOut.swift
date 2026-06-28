//
//  LogOut.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

protocol LogOutUseCaseProtocol: AnyObject{
    func excute()
}


final class LogOutUseCase: LogOutUseCaseProtocol{
    private var authRepo: AuthRepositoryProtocol
    
    init(authRepo: AuthRepositoryProtocol) {
        self.authRepo = authRepo
    }
    
    func excute() {
        authRepo.logout()
    }
}
