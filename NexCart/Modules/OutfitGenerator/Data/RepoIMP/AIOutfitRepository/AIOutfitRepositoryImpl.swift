//
//  AIOutfitRepositoryImpl.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

final class AIOutfitRepositoryImpl: AIOutfitRepositoryProtocol {
    
    func generate(request: OutfitRequest,provider: AIProvider) async throws -> GeneratedOutfit {
        do {
            return try await provider.generate(request: request)
        } catch let error as AIError {
            throw error
        } catch {
            throw AIError.generationFailed
        }
    }
}
