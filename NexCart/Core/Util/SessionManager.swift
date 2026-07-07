//
//  SessionManager.swift
//  NexCart
//
//  Created by Antoneos Philip on 06/07/2026.
//

import Foundation

protocol SessionManagerProtocol {
    func getUserEntity() -> UserEntity?
}

final class SessionManager: SessionManagerProtocol {
    func getUserEntity() -> UserEntity? {
        guard let data = UserDefaults.standard.data(forKey: "userEntity") else {
            return nil
        }
        do {
            return try JSONDecoder().decode(UserEntity.self, from: data)
        } catch {
            return nil
        }
    }
}
