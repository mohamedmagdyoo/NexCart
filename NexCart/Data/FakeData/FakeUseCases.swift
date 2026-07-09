//
//  FakeUseCases.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

// MARK: - Shared Mock User
private let mockUser = UserEntity(
    id: "mock-123",
    email: "test@nexcart.com",
    displayName: "Magdy",
    authProvider: .email,
    isGuest: false,
    shopifyCustomerId: "7592731234567",
    phone: "+201012345678",
    acceptsMarketing: true
)

private let mockGuestUser = UserEntity(
    id: "guest-000",
    email: "",
    displayName: "Guest",
    authProvider: .guest,
    isGuest: true,
    shopifyCustomerId: nil,
    phone: nil,
    acceptsMarketing: false
)
// MARK: - Login With Email
final class MockLoginWithEmailUseCase: LoginWithEmailUseCaseProtocol {
    var shouldFail = false

    func execute(credentials: EmailCredentials) async throws -> UserEntity {
        if shouldFail { throw AuthError.wrongPassword }
        return mockUser
    }
}

// MARK: - Login With Social Provider
final class MockLoginWithSocialProviderUseCase: LoginWithSocialProviderUseCaseProtocol {
    var shouldFail = false

    func excute(socialProvider: SocialAuthProvider) async throws -> UserEntity {
        if shouldFail { throw AuthError.socialLoginCancelled }
        return mockUser
    }
}

// MARK: - Login As Guest
final class MockLoginAsGuestUseCase: LoginAsGuestUseCaseProtocol {
    func excute() -> UserEntity {
        mockGuestUser
    }
}

// MARK: - Create New Account
final class MockCreateNewAccountUseCase: CreatNewAccountUseCaseProtocol {
    var shouldFail = false

    func excute(credentials: SignUpCredentials) async throws -> UserEntity {
        if shouldFail { throw AuthError.emailAlreadyInUse }
        return mockUser
    }
}

// MARK: - Forgot Password
final class MockForgotPassUseCase: ForgotPassUseCaseProtocol {
    var shouldFail = false

    func excute(email: String) async throws {
        if shouldFail { throw AuthError.userNotFound }
    }
}

// MARK: - Log Out
final class MockLogOutUseCase: LogOutUseCaseProtocol {
    func excute() {}
}
