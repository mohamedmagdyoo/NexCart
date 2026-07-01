//
//  FirebaseAuthRepository.swift
//  NexCart
//
//  Created by Mohamed Magdy on 29/06/2026.
//

import Foundation

import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

final class AuthRepository: AuthRepositoryProtocol {

    private let service: FirebaseAuthService
    //Should has other service for shopify ( post new customer)
    private let shopifyService: AuthShopifyServiceProtocol

    init(service: FirebaseAuthService, shopifyService: AuthShopifyServiceProtocol) {
        self.service = service
        self.shopifyService = shopifyService
    }
    
    func loginWithEmail(_ credentials: EmailCredentials) async throws -> UserEntity {
        do {
            let authUser = try await service.signIn(email: credentials.email,
                                            password: credentials.password)
            
            let shopifyUser = try await shopifyService.getShpifyCustomerByEmail(email: credentials.email)
            
            return mapToUserEntity(authUser, shopifyUser: shopifyUser)
        } catch let error as NSError {
            throw mapFirebaseError(error)
        }
    }

    func createAccount(with credentials: SignUpCredentials) async throws -> UserEntity {
        do {
            var shopifyUser = try await shopifyService.signUp(signUpCredentials: credentials).customer
            let authUser = try await service.signUp(email: credentials.email,
                                            password: credentials.password,
                                                    fullName: credentials.displayName)

            print("phoneFromDirctCredentials: \(credentials.phone ?? "NoPhone")")
            print("phoneFromshopifyService: \(shopifyUser.phone ?? "No Phone Found")")
            
            var userEntity = mapToUserEntity(authUser, shopifyUser: shopifyUser)
            userEntity.phone = credentials.phone
            return userEntity
        } catch let error as NSError {
            throw mapFirebaseError(error)
        }
    }

    func resetPassword(email: String) async throws {
        do {
            try await service.resetPassword(email: email)
        } catch let error as NSError {
            throw mapFirebaseError(error)
        }
    }
    
    // MARK: - Social
    func loginWithSocialProvider(_ provider: SocialAuthProvider) async throws -> UserEntity {
        switch provider {
        case .google(let viewController):
            do {
                
                let authUser = try await service.signInWithGoogle(presenting: viewController)
                
                return mapToUserEntity(authUser)
            } catch let error as NSError {
                throw mapFirebaseError(error)
            }

        case .apple(let authorization):
            do {
                let authUser =  try await service.signIn(with: authorization)
            
                return mapToUserEntity(authUser)
            } catch let error as NSError {
                throw mapFirebaseError(error)
            }
        }
    }


    // MARK: - Social
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

    // MARK: - Guest
    func continueAsGuest() -> UserEntity {
        UserEntity(
            id: UUID().uuidString,
            email: "",
            displayName: "Guest",
            authProvider: .guest,
            isGuest: true,
            shopifyCustomerId: nil,
            phone: nil,
            acceptsMarketing: false
        )
    }


    func logout() {
        try? service.signOut()
    }
    
}
