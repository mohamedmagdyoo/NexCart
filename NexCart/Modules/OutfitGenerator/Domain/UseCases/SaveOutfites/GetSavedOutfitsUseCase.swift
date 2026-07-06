//
//  GetSavedOutfitsUseCase.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

protocol GetSavedOutfitsUseCaseProtocol {
    func execute() async throws -> [GeneratedOutfit]
}

final class GetSavedOutfitsUseCase: GetSavedOutfitsUseCaseProtocol {
    private let repository: SavedOutfitRepositoryProtocol

    init(repository: SavedOutfitRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [GeneratedOutfit] {
        try await repository.getSaved()
    }
}
