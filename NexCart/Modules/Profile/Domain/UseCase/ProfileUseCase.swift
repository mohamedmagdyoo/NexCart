//
//  ProfileUseCase.swift
//  NexCart
//
//  Created by Antoneos Philip on 05/07/2026.
//

import Foundation

protocol ProfileUseCaseProtocol {
    func execute() async -> UserEntity?
}

class ProfileUseCase: ProfileUseCaseProtocol {
    private let repo: ProfileRepoProtocol
    
    init(repo: ProfileRepoProtocol = ProfileRepo()) {
        self.repo = repo
    }
    
    func execute() async -> UserEntity? {
        return await repo.getUserProfile()
    }
}
