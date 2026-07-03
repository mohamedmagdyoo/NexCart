//
//  FirebaseAuthService.swift
//  NexCart
//
//  Created by Mohamed Magdy on 29/06/2026.
//

import Foundation

import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import AuthenticationServices

final class FirebaseAuthService {
    
    // MARK: - Email & Password
    func signIn(email: String, password: String) async throws -> FirebaseAuth.User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result.user
    }
    
    func signUp(email: String, password: String, fullName: String) async throws -> FirebaseAuth.User {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        // Optionally set display name right after creation
        let changeRequest = result.user.createProfileChangeRequest()
        changeRequest.displayName = fullName
        try await changeRequest.commitChanges()
        return result.user
    }
    
    // MARK: - Google Sign In
    func signInWithGoogle(presenting viewController: UIViewController) async throws -> FirebaseAuth.User {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw AuthError.unknown(NSError(domain: "AuthError", code: -1))
            
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)
        
        guard let idToken = result.user.idToken?.tokenString else {
            throw AuthError.unknown(NSError(domain: "AuthError", code: -1))
        }
        let accessToken = result.user.accessToken.tokenString
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: accessToken)
        let firebaseResult = try await Auth.auth().signIn(with: credential)
        return firebaseResult.user
    }
    
    // MARK: - Apple Sign In
    func signIn(with authorization: ASAuthorization) async throws -> FirebaseAuth.User {
        guard
            let appleCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let tokenData = appleCredential.identityToken,
            let tokenString = String(data: tokenData, encoding: .utf8)
        else {
            throw AuthError.unknown(NSError(domain: "AuthError", code: -1))
        }
        
        let credential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: tokenString,
            rawNonce: ""
        )
        let result = try await Auth.auth().signIn(with: credential)
        return result.user
    }
    
    // MARK: - Other
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
