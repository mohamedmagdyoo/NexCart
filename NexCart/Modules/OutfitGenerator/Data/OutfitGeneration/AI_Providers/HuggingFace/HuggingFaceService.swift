//
//  HuggingFaceService.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

protocol HuggingFaceServiceProtocol {
    func generateImage(prompt: String) async throws -> Data
}

final class HuggingFaceService: HuggingFaceServiceProtocol {
    private let apiToken: String
    private let modelEndpoint = "https://router.huggingface.co/hf-inference/models/black-forest-labs/FLUX.1-schnell"
    private let session: URLSession

    init(apiToken: String, session: URLSession = .shared) {
        self.apiToken = apiToken
        self.session = session
    }

    func generateImage(prompt: String) async throws -> Data {
        guard let url = URL(string: modelEndpoint) else {
            throw HuggingFaceServiceError.invalidResponse
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = HuggingFaceRequestDTO(inputs: prompt)
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
            return data

        case 401, 403:
            throw HuggingFaceServiceError.invalidAPIKey

        case 503:
            let errorDTO = try? JSONDecoder().decode(HuggingFaceErrorDTO.self, from: data)
            throw HuggingFaceServiceError.modelLoading(estimatedSeconds: errorDTO?.estimatedTime)

        default:
            throw HuggingFaceServiceError.requestFailed(statusCode: httpResponse.statusCode)
        }
    }
}
