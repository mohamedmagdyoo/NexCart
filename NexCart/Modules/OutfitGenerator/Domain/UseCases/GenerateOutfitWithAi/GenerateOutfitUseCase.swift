//
//  GenerateOutfitUseCase.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

protocol GenerateOutfitUseCaseProtocol {
    func execute(request: OutfitRequest) async throws -> GeneratedOutfit
}

final class GenerateOutfitUseCase: GenerateOutfitUseCaseProtocol {
    private let repository: AIOutfitRepositoryProtocol

    init(repository: AIOutfitRepositoryProtocol) {
        self.repository = repository
    }

    func execute(request: OutfitRequest) async throws -> GeneratedOutfit {
        try await repository.generate(request: request)
    }
}
