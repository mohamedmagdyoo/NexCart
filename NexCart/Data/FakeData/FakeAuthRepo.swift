//
//  FakeAuthRepo.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

final class MockAuthRepository: AuthRepositoryProtocol {

    // MARK: - Control Flags (set these in your ViewController/Preview to simulate scenarios)
    var shouldFail = false
    var fakeUser = UserEntity(
        id: "mock-123",
        email: "test@nexcart.com",
        displayName: "Magdy",
        authProvider: .email,
        isGuest: false,
        shopifyCustomerId: "7592731234567",
        phone: "+201012345678",
        acceptsMarketing: true
    )

    func loginWithEmail(_ credentials: EmailCredentials) async throws -> UserEntity {
        if shouldFail { throw AuthError.wrongPassword }
        return fakeUser
    }

    func createAccount(with credentials: SignUpCredentials) async throws -> UserEntity {
        if shouldFail { throw AuthError.emailAlreadyInUse }
        return fakeUser
    }

    func loginWithSocialProvider(_ provider: SocialAuthProvider) async throws -> UserEntity {
        if shouldFail { throw AuthError.socialLoginCancelled }
        return fakeUser
    }

    func continueAsGuest() -> UserEntity {
        UserEntity(
            id: "guest-000",
            email: "",
            displayName: "Guest",
            authProvider: .guest,
            isGuest: true,
            shopifyCustomerId: nil,
            phone: nil,
            acceptsMarketing: false
        )
    }

    func resetPassword(email: String) async throws {
        if shouldFail { throw AuthError.userNotFound }
    }

    func logout() {}

    func getCurrentUser() -> UserEntity? {
        return shouldFail ? nil : fakeUser
    }
}
