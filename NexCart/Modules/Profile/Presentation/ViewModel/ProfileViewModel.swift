//
//  ProfileViewModel.swift
//  NexCart
//
//  Created by Antoneos Philip on 05/07/2026.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: UserEntity?
    
    private let profileUseCase: ProfileUseCaseProtocol
    private let logOutUseCase: LogOutUseCaseProtocol?
    
    init(profileUseCase: ProfileUseCaseProtocol = ProfileUseCase(), logOutUseCase: LogOutUseCaseProtocol? = DIContainer.shared.container.resolve(LogOutUseCaseProtocol.self)) {
        self.profileUseCase = profileUseCase
        self.logOutUseCase = logOutUseCase
    }
    
    func fetchProfile() {
        Task {
            self.user = await profileUseCase.execute()
        }
    }
    
    func logout() {
        logOutUseCase?.excute()
    }
}
