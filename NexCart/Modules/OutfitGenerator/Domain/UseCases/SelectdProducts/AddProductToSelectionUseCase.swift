//
//  AddProductToSelectionUseCase.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

protocol AddProductToSelectionUseCaseProtocol {
    func execute(product: SelectedProduct) async throws
}

final class AddProductToSelectionUseCase: AddProductToSelectionUseCaseProtocol {
    private let repository: OutfitSelectionRepositoryProtocol

    init(repository: OutfitSelectionRepositoryProtocol) {
        self.repository = repository
    }

    func execute(product: SelectedProduct) async throws {
        try await repository.add(product)
    }
}
