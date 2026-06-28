//
//  DIContainer.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

import Swinject

final class DIContainer {
    static let shared = DIContainer()
    let container = Container()

    private init() {
        registerAll()
    }

    private func registerAll() {
        registerRepositories()
        registerUseCases()
        registerViewModels()
    }
}
