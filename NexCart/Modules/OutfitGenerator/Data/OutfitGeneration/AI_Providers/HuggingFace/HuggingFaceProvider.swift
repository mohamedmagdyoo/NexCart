//
//  HuggingFaceProvider.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation


final class HuggingFaceProvider: AIProvider {
    private let service: HuggingFaceServiceProtocol

    init(service: HuggingFaceServiceProtocol) {
        self.service = service
    }

    func generate(request: OutfitRequest) async throws -> GeneratedOutfit {
        let prompt = buildPrompt(from: request)

        do {
            let imageData = try await service.generateImage(prompt: prompt)
            return GeneratedOutfit(
                id: UUID().uuidString,
                imageData: imageData,
                generatedAt: Date()
            )
        } catch let error as HuggingFaceServiceError {
            throw mapToAIError(error)
        }
    }

    private func buildPrompt(from request: OutfitRequest) -> String {
        let items = request.selectedProducts.map { $0.title }.joined(separator: ", ")
        return "A stylish outfit combining: \(items). Fashion photography, clean background."
    }

    private func mapToAIError(_ error: HuggingFaceServiceError) -> AIError {
        switch error {
        case .invalidAPIKey:
            return .invalidAPIKey
        case .modelLoading, .requestFailed, .invalidResponse, .decodingFailed:
            return .generationFailed
        }
    }
}
