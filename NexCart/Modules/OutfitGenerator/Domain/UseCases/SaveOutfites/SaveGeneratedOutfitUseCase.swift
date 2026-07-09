//
//  SaveGeneratedOutfitUseCase.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation


protocol SaveGeneratedOutfitUseCaseProtocol {
    func execute(outfit: GeneratedOutfit) async throws
}

final class SaveGeneratedOutfitUseCase: SaveGeneratedOutfitUseCaseProtocol {
    private let repository: SavedOutfitRepositoryProtocol

    init(repository: SavedOutfitRepositoryProtocol) {
        self.repository = repository
    }

    func execute(outfit: GeneratedOutfit) async throws {
        try await repository.save(outfit)
    }
}
