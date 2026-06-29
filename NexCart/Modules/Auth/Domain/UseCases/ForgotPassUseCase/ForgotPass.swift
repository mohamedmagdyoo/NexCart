//
//  ForgotPass.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation


protocol ForgotPassUseCaseProtocol: AnyObject{
    func excute(email: String) async throws
    
}


final class ForgotPassUseCase: ForgotPassUseCaseProtocol{
    private var authRepo: AuthRepositoryProtocol
    
    init(authRepo: AuthRepositoryProtocol) {
        self.authRepo = authRepo
    }
    
    func excute(email: String) async throws {
        try await authRepo.resetPassword(email: email)
    }
}
