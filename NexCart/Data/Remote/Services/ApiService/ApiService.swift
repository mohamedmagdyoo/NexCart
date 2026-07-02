//
//  ApiService.swift
//  MVVM+CleanArch
//
//  Created by Mohamed Magdy on 11/05/2026.
//

import Foundation

class ApiService : ApiServiceProtocol{
    //where T : Decodable
    func fetch<T>(endPoint: EndPoint) async throws -> T where T: Decodable {
        guard let url = URL(string: endPoint.baseUrl + endPoint.path) else { throw URLError(.badURL) }

        #if DEBUG
        print("🌐 API Request: \(url.absoluteString)")
        #endif

        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.uppercased()
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(endPoint.ApiToken, forHTTPHeaderField: "X-Shopify-Access-Token")
        request.httpBody = endPoint.body

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            #if DEBUG
            if let errStr = String(data: data, encoding: .utf8) {
                print("❌ Error body: \(errStr)")
            }
            #endif
            throw URLError(.badServerResponse,
                           userInfo: [NSLocalizedDescriptionKey: "HTTP \(code)"])
        }

        #if DEBUG
        if let jsonStr = String(data: data, encoding: .utf8) {
            let preview = String(jsonStr.prefix(500))
            print("📦 Response (\(data.count) bytes): \(preview)...")
        }
        #endif

        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func post<Response: Decodable, Body: Encodable>(
        endPoint: EndPoint,
        body: Body
    ) async throws -> Response {

        guard let url = URL(string: endPoint.baseUrl + endPoint.path) else {
            throw URLError(.badURL)
        }

        #if DEBUG
        print("🌐 API Request: \(url.absoluteString)")
        #endif

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(endPoint.ApiToken, forHTTPHeaderField: "X-Shopify-Access-Token")

        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {

            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw URLError(
                .badServerResponse,
                userInfo: [NSLocalizedDescriptionKey: "HTTP \(code)"]
            )
        }

        #if DEBUG
        if let jsonStr = String(data: data, encoding: .utf8) {
            print("📦 Response: \(jsonStr)")
        }
        #endif

        return try JSONDecoder().decode(Response.self, from: data)
    }
    
}
