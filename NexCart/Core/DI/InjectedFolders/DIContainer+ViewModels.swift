//
//  DIContainer+ViewModels.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation
import Swinject

extension DIContainer {
    func registerViewModels() {
        container.register(SignInViewModel.self) { r in
            SignInViewModel(
                loginWithEmailPassUC: r.resolve(LoginWithEmailUseCaseProtocol.self)!,
                loginWithProviderUC: r.resolve(LoginWithSocialProviderUseCaseProtocol.self)!,
                loginAsGuestUC: r.resolve(LoginAsGuestUseCaseProtocol.self)!
            )
        }

//        container.register(SignUpViewModel.self) { r in
//            SignUpViewModel(
//                createAccountUseCase: r.resolve(CreatNewAccountUseCaseProtocol.self)!
//            )
//        }

    }
}
