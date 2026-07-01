//
//  AuthMappers.swift
//  NexCart
//
//  Created by Mohamed Magdy on 29/06/2026.
//

import Foundation

import FirebaseAuth
import GoogleSignIn
import AuthenticationServices

//MARK: Mappers
func mapFirebaseError(_ error: Error) -> AuthError {
    let nsError = error as NSError
    
    guard let authError = AuthErrorCode.Code(rawValue: nsError.code) else {
        return .unknown(error)
    }
    
    switch authError {
    case .wrongPassword, .invalidCredential, .invalidEmail:
        return .wrongPassword
        
    case .emailAlreadyInUse:
        return .emailAlreadyInUse
        
    case .userNotFound:
        return .userNotFound
        
    case .networkError:
        return .networkError
        
    default:
        return .unknown(error)
    }
}


func mapToUserEntity(_ user: FirebaseAuth.User) -> UserEntity {
    UserEntity(
        id: user.uid,
        email: user.email ?? "",
        displayName: user.displayName ?? "",
        authProvider: detectProvider(user),
        isGuest: false,
        shopifyCustomerId: nil,
        phone: nil,
        acceptsMarketing: false
    )
}

func mapToUserEntity(
    _ user: FirebaseAuth.User,
    shopifyUser: ShopifyCustomerDTO,
    acceptsMarketing: Bool = true
) -> UserEntity {
    UserEntity(
        id: user.uid,
        email: user.email ?? shopifyUser.email ?? "",
        displayName: user.displayName ?? "\(shopifyUser.firstName ?? "") \(shopifyUser.lastName ?? "")".trimmingCharacters(in: .whitespaces),
        authProvider: detectProvider(user),
        isGuest: false,
        shopifyCustomerId: String(shopifyUser.id),
        phone: shopifyUser.phone,
        acceptsMarketing: acceptsMarketing
    )
}

private func detectProvider(_ user: FirebaseAuth.User) -> AuthProvider {
    let providerID = user.providerData.first?.providerID ?? ""
    switch providerID {
    case "google.com":  return .google
    case "apple.com":   return .apple
    case "password":    return .email
    default:            return .email
    }
}
