//
//  AuthError.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

enum AuthError: Error, LocalizedError {
    case invalidEmail
    case weakPassword
    case emailAlreadyInUse
    case wrongPassword
    case passwordsDidNotMatchConfirmedPass
    case userNotFound
    case networkError
    case socialLoginCancelled
    case unknown(Error)
    
    var errorDescription: String {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address."
        case .weakPassword:
            return "Password must be at least 8 characters."
        case .emailAlreadyInUse:
            return "An account with this email already exists."
        case .wrongPassword:
            return "Incorrect password. Please try again."
        case .userNotFound:
            return "No account found with this email."
        case .networkError:
            return "Network error. Please check your connection and try again."
        case .socialLoginCancelled:
            return "Sign in was cancelled."
        case .unknown(let error):
            return error.localizedDescription
        case .passwordsDidNotMatchConfirmedPass:
            return "The pass don't mathc the confirm pass"
        }
    }
}
