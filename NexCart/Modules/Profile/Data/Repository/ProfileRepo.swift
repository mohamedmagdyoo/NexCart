//
//  ProfileRepo.swift
//  NexCart
//
//  Created by Antoneos Philip on 05/07/2026.
//

import Foundation

class ProfileRepo: ProfileRepoProtocol {
    func getUserProfile() async -> UserEntity? {
        return await AppConstants.shared.getUserEntity()
    }
}





















