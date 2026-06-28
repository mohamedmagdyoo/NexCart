//
//  DIContainer+Repositories.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

import Swinject

extension DIContainer {
    func registerRepositories() {
        container.register(AuthRepositoryProtocol.self) { _ in
            MockAuthRepository()
        }.inObjectScope(.container) // to make it singltone
    }
}
