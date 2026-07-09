//
//  HuggingFaceProvider.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

final class HuggingFaceProvider: AIProvider {
    private let service: HuggingFaceServiceProtocol
    private let imageDownloadService: ImageDownloadServiceProtocol
    private let imageCompositionService: ImageCompositionServiceProtocol

    init(
        service: HuggingFaceServiceProtocol,
        imageDownloadService: ImageDownloadServiceProtocol,
        imageCompositionService: ImageCompositionServiceProtocol
    ) {
        self.service = service
        self.imageDownloadService = imageDownloadService
        self.imageCompositionService = imageCompositionService
    }

    func generate(request: OutfitRequest) async throws -> GeneratedOutfit {
        print("Gen with Huggin Face")
        let prompt = buildPrompt(from: request)

        do {
            let imageDatas = try await downloadAllImages(for: request.selectedProducts)
            let compositeImageData = try imageCompositionService.composite(images: imageDatas)
            let base64Image = compositeImageData.base64EncodedString()

            let generatedImageData = try await service.generateImage(
                prompt: prompt,
                referenceImageBase64: base64Image
            )

            return GeneratedOutfit(
                id: UUID().uuidString,
                imageData: generatedImageData,
                generatedAt: Date()
            )
        } catch let error as HuggingFaceServiceError {
            print("🔴 HuggingFace service error: \(error)")
            throw mapToAIError(error)
        } catch let error as ImageDownloadError {
            print("🔴 Image download error: \(error)")
            throw AIError.generationFailed
        } catch let error as ImageCompositionError {
            print("🔴 Image composition error: \(error)")
            throw AIError.generationFailed
        } catch {
            print("🔴 Unknown error: \(error)")
            throw AIError.generationFailed
        }
    }

    private func downloadAllImages(for products: [SelectedProduct]) async throws -> [Data] {
        var results = [Data?](repeating: nil, count: products.count)

        try await withThrowingTaskGroup(of: (Int, Data).self) { group in
            for (index, product) in products.enumerated() {
                group.addTask {
                    let data = try await self.imageDownloadService.downloadImage(from: product.imageURL)
                    return (index, data)
                }
            }
            for try await (index, data) in group {
                results[index] = data
            }
        }

        return results.compactMap { $0 }
    }

    private func buildPrompt(from request: OutfitRequest) -> String {
        let items = request.selectedProducts.enumerated().map { index, product -> String in
            var line = "Item \(index + 1): \(product.title)"
            if let category = product.category { line += " (\(category))" }
            if let color = product.color { line += ", \(color)" }
            return line
        }.joined(separator: "\n")

        return """
        The attached reference image is a flat-lay product grid showing separate clothing items — it is NOT a photo to edit or preserve.

        Items shown in the reference:
        \(items)

        Task:
        Completely discard the reference image's flat-lay layout, plain background, and grid arrangement. Generate an entirely new, different photograph: a full-body, vertical, editorial-style photo of an attractive human fashion model actually wearing all of these exact items together as one outfit.

        Requirements:
        - Do NOT reproduce the flat-lay grid or product-photo style in any way — the output must show a real person, standing, wearing the clothes.
        - Preserve only the exact color, pattern, material, and logos of each item, not the composition or background of the reference image.
        - Combine all compatible items onto the same person; choose the most realistic combination if some items conflict.
        - Add only minimal complementary pieces if needed to complete the look.
        - Full body visible, vertical portrait orientation.
        - Studio lighting, neutral background, ultra-photorealistic, high-end fashion editorial quality.
        """
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
