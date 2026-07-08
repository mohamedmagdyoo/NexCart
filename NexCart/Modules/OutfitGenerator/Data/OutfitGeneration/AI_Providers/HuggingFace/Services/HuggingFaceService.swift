//
//  HuggingFaceService.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

protocol HuggingFaceServiceProtocol {
    func generateImage(prompt: String, referenceImageBase64: String) async throws -> Data
}

struct HuggingFaceImageRequestDTO: Encodable {
    let prompt: String
    let image_url: String
    let resolution_mode: String
    let guidance_scale: Double
}

struct HuggingFaceImageResponseDTO: Decodable {
    let images: [ImageResult]

    struct ImageResult: Decodable {
        let url: String
    }
}

final class HuggingFaceService: HuggingFaceServiceProtocol {
    private let modelEndpoint = "https://router.huggingface.co/fal-ai/fal-ai/flux-kontext/dev"
    private let session: URLSession
    private let imageDownloadService: ImageDownloadServiceProtocol

    init(
        session: URLSession = .shared,
        imageDownloadService: ImageDownloadServiceProtocol = ImageDownloadService()
    ) {
        self.session = session
        self.imageDownloadService = imageDownloadService
    }

    func generateImage(prompt: String, referenceImageBase64: String) async throws -> Data {
        let apiToken: String = ""

        guard let url = URL(string: modelEndpoint) else {
            throw HuggingFaceServiceError.invalidResponse
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 120 // Kontext generations can take longer than the 60s default

        let dataURI = "data:image/jpeg;base64,\(referenceImageBase64)"
        let body = HuggingFaceImageRequestDTO(
            prompt: prompt,
            image_url: dataURI,
            resolution_mode: "9:16",   // force portrait instead of match_input
            guidance_scale: 5.0        // push harder toward following the prompt (default is 2.5)
        )
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw HuggingFaceServiceError.invalidResponse
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw HuggingFaceServiceError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401, 403:
            throw HuggingFaceServiceError.invalidAPIKey
        case 503:
            let errorDTO = try? JSONDecoder().decode(HuggingFaceErrorDTO.self, from: data)
            throw HuggingFaceServiceError.modelLoading(estimatedSeconds: errorDTO?.estimatedTime)
        default:
            throw HuggingFaceServiceError.requestFailed(statusCode: httpResponse.statusCode)
        }

        guard let decoded = try? JSONDecoder().decode(HuggingFaceImageResponseDTO.self, from: data),
              let resultImageURLString = decoded.images.first?.url else {
            throw HuggingFaceServiceError.decodingFailed
        }

        // fal returns a URL to the generated image, not the bytes — fetch it
        return try await imageDownloadService.downloadImage(from: resultImageURLString)
    }
}
