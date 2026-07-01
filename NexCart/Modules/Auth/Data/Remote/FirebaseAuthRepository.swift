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

final class FirebaseAuthRepository: AuthRepositoryProtocol {

    private let service: FirebaseAuthService
    //Should has other service for shopify ( post new customer)

    init(service: FirebaseAuthService) {
        self.service = service
    }


    func loginWithEmail(_ credentials: EmailCredentials) async throws -> UserEntity {
        do {
            let authUser = try await service.signIn(email: credentials.email,
                                            password: credentials.password)
            return mapToUserEntity(authUser)
        } catch let error as NSError {
            throw mapFirebaseError(error)
        }
    }

    func createAccount(with credentials: SignUpCredentials) async throws -> UserEntity {
        do {
            let authUser = try await service.signUp(email: credentials.email,
                                            password: credentials.password,
                                                    fullName: credentials.displayName)
            return mapToUserEntity(authUser)
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

    // MARK: - Guest
    func continueAsGuest() -> UserEntity {

        UserEntity(
            id: UUID().uuidString,
            email: "",
            displayName: "Guest",
            authProvider: .guest,
            isGuest: true
        )
    }


    func logout() {
        try? service.signOut()
    }
    
}
