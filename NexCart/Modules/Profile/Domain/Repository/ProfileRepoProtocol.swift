//
//  ProfileRepoProtocol.swift
//  NexCart
//
//  Created by Antoneos Philip on 05/07/2026.
//

import Foundation

protocol ProfileRepoProtocol {
    func getUserProfile() async -> UserEntity?
}
