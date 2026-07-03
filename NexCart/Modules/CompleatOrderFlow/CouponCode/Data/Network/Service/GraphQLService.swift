//
//  GraphQLService.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import Foundation


protocol GraphQLServiceProtocol {
    func fetch<T: Decodable>(query: String, variables: [String: Any]) async throws -> T
}

final class ShopifyGraphQLService: GraphQLServiceProtocol {
    private let baseURL: URL          // e.g. https://mad46-ios-team9.myshopify.com/admin/api/2026-01/
    private let accessToken: String
    private let session: URLSession

    init(baseURL: URL, accessToken: String, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.accessToken = accessToken
        self.session = session
    }

    func fetch<T: Decodable>(query: String, variables: [String: Any]) async throws -> T {
        var request = URLRequest(url: baseURL.appendingPathComponent("graphql.json"))
        request.httpMethod = "POST"
        request.setValue(accessToken, forHTTPHeaderField: "X-Shopify-Access-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: ["query": query, "variables": variables])

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
             throw URLError(
                 .badServerResponse,
                 userInfo: [NSLocalizedDescriptionKey: "HTTP \(code)"]
             )
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

