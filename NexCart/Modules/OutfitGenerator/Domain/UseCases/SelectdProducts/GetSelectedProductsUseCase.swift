//
//  GetSelectedProductsUseCase.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

protocol GetSelectedProductsUseCaseProtocol {
    func execute() async -> [SelectedProduct]
}

final class GetSelectedProductsUseCase: GetSelectedProductsUseCaseProtocol {
    private let repository: OutfitSelectionRepositoryProtocol

    init(repository: OutfitSelectionRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async -> [SelectedProduct] {
        await repository.getAll()
    }
}
