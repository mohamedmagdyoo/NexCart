//
//  AppConstantes.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import Foundation


class AppConstants {
    static let shared = AppConstants()
    
    private init() {}
    
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
