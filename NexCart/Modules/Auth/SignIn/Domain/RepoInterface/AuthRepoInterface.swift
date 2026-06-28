//
//  AuthRepoInterface.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

protocol AuthRepositoryProtocol: AnyObject {

    // Email
    func loginWithEmail(_ credentials: EmailCredentials) async throws -> UserEntity
    func createAccount(with credentials: SignUpCredentials) async throws -> UserEntity
    func resetPassword(email: String) async throws

    // Social  ← single method with enum has all the providers
    func loginWithSocialProvider(_ provider: SocialAuthProvider) async throws -> UserEntity

    // Guest
    func continueAsGuest() -> UserEntity

    // Session
    func logout()
}
