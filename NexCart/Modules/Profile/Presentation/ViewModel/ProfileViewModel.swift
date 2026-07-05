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
    
    init(profileUseCase: ProfileUseCaseProtocol = ProfileUseCase()) {
        self.profileUseCase = profileUseCase
    }
    
    
    
    func fetchProfile() {
        Task {
            self.user = await profileUseCase.execute()
        }
    }
}
