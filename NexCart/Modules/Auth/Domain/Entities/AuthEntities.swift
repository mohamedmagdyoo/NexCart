//
//  AuthEntities.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation
import UIKit
import AuthenticationServices

struct UserEntity: Codable {
    let id: String
    let email: String
    let displayName: String?
    let authProvider: AuthProvider
    let isGuest: Bool
}

enum AuthProvider: Codable {
    case email
    case google
    case apple
    case guest
}

// For email/password login
struct EmailCredentials {
    let email: String
    let password: String
}

// For sign up we need name too
struct SignUpCredentials {
    let name: String
    let email: String
    let password: String
}

// SocialProviders
enum SocialAuthProvider {
    case google(vc: UIViewController)
    case apple(authorization: ASAuthorization)
}
