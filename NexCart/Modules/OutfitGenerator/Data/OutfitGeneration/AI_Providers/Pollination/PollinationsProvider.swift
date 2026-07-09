//
//  PollinationsProvider.swift
//  NexCart
//
//  Created by shady ramadan on 07/07/2026.
//

import Foundation

final class PollinationsProvider: AIProvider {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func generate(request: OutfitRequest) async throws -> GeneratedOutfit {
        let prompt = buildPrompt(from: request)
        print("🎨 Pollinations prompt: \(prompt)")

        guard let encodedPrompt = prompt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://image.pollinations.ai/prompt/\(encodedPrompt)?width=768&height=1024&model=flux&nologo=true&enhance=true")
        else {
            print("❌ Pollinations: invalid URL")
            throw AIError.generationFailed
        }

        print("🌐 Pollinations URL: \(url)")

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.timeoutInterval = 120

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            print("❌ Pollinations network error: \(error)")
            throw AIError.generationFailed
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            print("❌ Pollinations: invalid response type")
            throw AIError.generationFailed
        }

        print("✅ Pollinations status: \(httpResponse.statusCode), data size: \(data.count) bytes")

        guard (200...299).contains(httpResponse.statusCode) else {
            print("❌ Pollinations bad status: \(httpResponse.statusCode)")
            throw AIError.generationFailed
        }

        guard !data.isEmpty else {
            print("❌ Pollinations: empty data")
            throw AIError.generationFailed
        }

        return GeneratedOutfit(
            id: UUID().uuidString,
            imageData: data,
            generatedAt: Date()
        )
    }

    private func buildPrompt(from request: OutfitRequest) -> String {
            // 1. تفكيك كل منتج واستخدام كل الـ Features بتاعته لبناء وصف هيكلي دقيق
            let itemizedOutfits = request.selectedProducts.enumerated().map { (index, product) -> String in
                let title = product.title
                // لو مفيش داتا بنحط قيم افتراضية عشان الـ Prompt ميبقاش ناقص
                let category = (product.category?.isEmpty == false) ? product.category! : "apparel piece"
                let brand = (product.brand?.isEmpty == false) ? product.brand! : "premium retail brand"
                let color = (product.color?.isEmpty == false) ? product.color! : "matching"
                
                return """
                - Piece \(index + 1) [\(category.uppercased())]: A strictly realistic \(color) \(category) designed by \(brand). Exact retail item name: "\(title)". \
                Features standard commercial tailoring, visible high-quality fabric texture (appropriate to the item type), precise physical seams, realistic hems, and authentic garment proportions.
                """
            }.joined(separator: "\n")

            // 2. الـ Master Prompt: بيقفل على الـ AI كل سكك التهييس ويجبره على الواقعية
            let prompt = """
            Ultra-realistic, 8k resolution, high-end commercial e-commerce fashion photography. A professional human model standing in a bright, clean, minimalist white photography studio. \
            The model is wearing a meticulously styled, highly accurate retail outfit consisting EXACTLY of the following separate pieces:
            
            \(itemizedOutfits)
            
            CRITICAL GENERATION INSTRUCTIONS:
            1. STRUCTURAL INTEGRITY: Maintain absolute structural boundaries for every garment. Do NOT merge or blend pieces. A jacket must look like a real physical jacket, pants must look like real pants.
            2. TEXTILE REALISM: Hyper-detailed textile rendering. Show the authentic fabric weave, natural clothing drapery, realistic wrinkles, and crisp stitching lines. 
            3. COMMERCIAL AESTHETIC: The lighting must be soft, dramatic studio lighting with realistic drop shadows. Sharp focus on the apparel. No CGI look, no illustration, no distorted AI artifacts. The clothing must look exactly like ready-to-wear physical items from a luxury fashion catalog.
            """

            return prompt
        }
}
//
//  PollinationsProvider.swift
//  NexCart
//
//  Created by shady ramadan on 07/07/2026.
//
//
//import Foundation
//import os
//
//final class PollinationsProvider: AIProvider {
//
//    private let session: URLSession
//    private let logger = Logger(subsystem: "NexCart", category: "PollinationsProvider")
//
//    private let imageWidth = 768
//    private let imageHeight = 1024
//    private let maxRetries = 2
//    private let baseTimeout: TimeInterval = 120
//
//    init(session: URLSession = .shared) {
//        self.session = session
//    }
//
//    func generate(request: OutfitRequest) async throws -> GeneratedOutfit {
//        guard !request.selectedProducts.isEmpty else {
//            logger.error("Pollinations: no products in request")
//            throw AIError.generationFailed
//        }
//
//        let prompt = buildPrompt(from: request)
//        logger.debug("Pollinations prompt: \(prompt, privacy: .public)")
//
//        guard let url = buildURL(prompt: prompt) else {
//            logger.error("Pollinations: invalid URL")
//            throw AIError.generationFailed
//        }
//
//        logger.debug("Pollinations URL: \(url.absoluteString, privacy: .public)")
//
//        var lastError: Error?
//        for attempt in 0...maxRetries {
//            do {
//                try Task.checkCancellation()
//                let data = try await performRequest(url: url)
//                return GeneratedOutfit(
//                    id: UUID().uuidString,
//                    imageData: data,
//                    generatedAt: Date()
//                )
//            } catch {
//                lastError = error
//                logger.error("Pollinations attempt \(attempt + 1) failed: \(String(describing: error), privacy: .public)")
//                if error is CancellationError { throw error }
//                if attempt < maxRetries {
//                    let backoff = UInt64(pow(2.0, Double(attempt))) * 1_000_000_000
//                    try? await Task.sleep(nanoseconds: backoff)
//                }
//            }
//        }
//
//        logger.error("Pollinations: exhausted retries, last error: \(String(describing: lastError), privacy: .public)")
//        throw AIError.generationFailed
//    }
//
//    private func buildURL(prompt: String) -> URL? {
//        guard let encodedPrompt = prompt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
//            return nil
//        }
//
//        var components = URLComponents(string: "https://image.pollinations.ai/prompt/\(encodedPrompt)")
//        components?.queryItems = [
//            URLQueryItem(name: "width", value: String(imageWidth)),
//            URLQueryItem(name: "height", value: String(imageHeight)),
//            URLQueryItem(name: "model", value: "flux"),
//            URLQueryItem(name: "nologo", value: "true"),
//            URLQueryItem(name: "enhance", value: "true"),
//            URLQueryItem(name: "seed", value: String(Int.random(in: 0...Int.max)))
//        ]
//        return components?.url
//    }
//
//    private func performRequest(url: URL) async throws -> Data {
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "GET"
//        urlRequest.timeoutInterval = baseTimeout
//
//        let (data, response): (Data, URLResponse)
//        do {
//            (data, response) = try await session.data(for: urlRequest)
//        } catch {
//            throw AIError.generationFailed
//        }
//
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw AIError.generationFailed
//        }
//
//        logger.debug("Pollinations status: \(httpResponse.statusCode), size: \(data.count) bytes")
//
//        guard (200...299).contains(httpResponse.statusCode) else {
//            throw AIError.generationFailed
//        }
//
//        guard !data.isEmpty else {
//            throw AIError.generationFailed
//        }
//
//        return data
//    }
//
//    private func buildPrompt(from request: OutfitRequest) -> String {
//        let itemizedOutfits = request.selectedProducts.enumerated().map { index, product -> String in
//            let category = sanitize(product.category, fallback: "apparel piece")
//            let brand = sanitize(product.brand, fallback: "premium retail brand")
//            let color = sanitize(product.color, fallback: "matching")
//            let title = sanitize(product.title, fallback: "unlabeled item")
//
//            return """
//            - Piece \(index + 1) [\(category.uppercased())]: A strictly realistic \(color) \(category) designed by \(brand). Exact retail item name: "\(title)". \
//            Features standard commercial tailoring, visible high-quality fabric texture (appropriate to the item type), precise physical seams, realistic hems, and authentic garment proportions.
//            """
//        }.joined(separator: "\n")
//
//        return """
//        Ultra-realistic, 8k resolution, high-end commercial e-commerce fashion photography. A professional human model standing in a bright, clean, minimalist white photography studio. \
//        The model is wearing a meticulously styled, highly accurate retail outfit consisting EXACTLY of the following separate pieces:
//
//        \(itemizedOutfits)
//
//        CRITICAL GENERATION INSTRUCTIONS:
//        1. STRUCTURAL INTEGRITY: Maintain absolute structural boundaries for every garment. Do NOT merge or blend pieces. A jacket must look like a real physical jacket, pants must look like real pants.
//        2. TEXTILE REALISM: Hyper-detailed textile rendering. Show the authentic fabric weave, natural clothing drapery, realistic wrinkles, and crisp stitching lines.
//        3. COMMERCIAL AESTHETIC: The lighting must be soft, dramatic studio lighting with realistic drop shadows. Sharp focus on the apparel. No CGI look, no illustration, no distorted AI artifacts. The clothing must look exactly like ready-to-wear physical items from a luxury fashion catalog.
//        """
//    }
//
//    private func sanitize(_ value: String?, fallback: String) -> String {
//        guard let value, !value.isEmpty else { return fallback }
//        return value
//            .replacingOccurrences(of: "\"", with: "")
//            .replacingOccurrences(of: "\n", with: " ")
//            .trimmingCharacters(in: .whitespacesAndNewlines)
//    }
//}
