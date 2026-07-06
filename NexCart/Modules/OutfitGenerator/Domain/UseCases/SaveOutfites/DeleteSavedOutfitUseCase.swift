//
//  DeleteSavedOutfitUseCase.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

protocol DeleteSavedOutfitUseCaseProtocol {
    func execute(id: String) async throws
}

final class DeleteSavedOutfitUseCase: DeleteSavedOutfitUseCaseProtocol {
    private let repository: SavedOutfitRepositoryProtocol

    init(repository: SavedOutfitRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: String) async throws {
        try await repository.delete(id: id)
    }
}
