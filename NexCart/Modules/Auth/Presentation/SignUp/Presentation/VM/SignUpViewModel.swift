//
//  SignUpViewModel.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

final class SignUpViewModel: ObservableObject {
    @Published var shouldNavigateToHome: Bool = false
    @Published var screenState: ScreenState = .idle
    @Published var alert: AlertModel?

    // MARK: - Use Cases
    private let signUpUseCase: CreatNewAccountUseCaseProtocol
    private let loginWithProviderUC: LoginWithSocialProviderUseCaseProtocol
    
    private var userEntity: UserEntity?

    init(
        signUpUseCase: CreatNewAccountUseCaseProtocol,
        loginWithProviderUC: LoginWithSocialProviderUseCaseProtocol
    ) {
        self.signUpUseCase = signUpUseCase
        self.loginWithProviderUC = loginWithProviderUC
    }

    // MARK: - Create New Account
    func createNewAccount(credentials: SignUpCredentials) {
        screenState = .loading
        Task { @MainActor in
            do {
                userEntity = try await signUpUseCase.excute(credentials: credentials)
                screenState = .success
            } catch let error as AuthError {
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
    
    func saveUserEntity(){
        guard let userEntity = userEntity else{
            screenState = .error(error: "Error, try again...")
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
