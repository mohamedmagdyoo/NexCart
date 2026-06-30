//
//  SignInViewModel.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

enum SignInScreenState {
    case idle
    case loading
    case success
}

struct AlertModel: Identifiable {
    var id: UUID = UUID()
    var title: String
    var description: String
}

final class SignInViewModel: ObservableObject {
    @Published var shouldNavigateToHome: Bool = false
    @Published var screenState: SignInScreenState = .idle
    @Published var alert: AlertModel?

    // MARK: - Use Cases
    private let loginWithEmailPassUC: LoginWithEmailUseCaseProtocol
    private let loginWithProviderUC: LoginWithSocialProviderUseCaseProtocol
    private let loginAsGuestUC: LoginAsGuestUseCaseProtocol
    
    private var userEntity: UserEntity?

    init(
        loginWithEmailPassUC: LoginWithEmailUseCaseProtocol,
        loginWithProviderUC: LoginWithSocialProviderUseCaseProtocol,
        loginAsGuestUC: LoginAsGuestUseCaseProtocol
    ) {
        self.loginWithEmailPassUC = loginWithEmailPassUC
        self.loginWithProviderUC = loginWithProviderUC
        self.loginAsGuestUC = loginAsGuestUC
    }

    // MARK: - Login with Email & Password
    func loginWithEmailAndPass(credentials: EmailCredentials) {
        screenState = .loading
        Task { @MainActor in
            do {
                userEntity = try await loginWithEmailPassUC.execute(credentials: credentials)
                screenState = .success
            } catch let error as AuthError {
                print("ErrorIs: \(error.errorDescription)")
                alert = AlertModel(title: "Error", description: error.errorDescription)
                screenState = .idle
            }
        }
    }

    // MARK: - Login with Social Provider
    func loginWithSocialProvider(provider: SocialAuthProvider) {
        screenState = .loading
        Task { @MainActor in
            do {
                userEntity = try await loginWithProviderUC.excute(socialProvider: provider)
                screenState = .success
            } catch let error as AuthError {
                alert = AlertModel(title: "Error", description: error.errorDescription)
                screenState = .idle
            }
        }
    }

    // MARK: - Login as Guest
    func loginAsGuest() {
        userEntity = loginAsGuestUC.excute()
        screenState = .success
        self.shouldNavigateToHome = true
    }
    
    // To emity that there a new user loged in and restate the content view to nav to home screen direct
    func saveUser(){
        guard let userEntity = userEntity else{
            alert = AlertModel(title: "Wrong With Login Try Again..",description: "try agian...")
            return
        }
        
        saveUser(userEntity)
        self.shouldNavigateToHome = true
    }

    // MARK: - Private Helpers
    private func saveUser(_ userEntity: UserEntity) {
        guard let userData = try? JSONEncoder().encode(userEntity) else { return }
        UserDefaults.standard.set(userData, forKey: "userEntity")
        
    }
}
