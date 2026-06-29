//
//  ApiService.swift
//  MVVM+CleanArch
//
//  Created by Mohamed Magdy on 11/05/2026.
//

import Foundation

class ApiService : ApiServiceProtocol{
    //where T : Decodable
//    func fetch<T>(endPoint: EndPoint) async throws -> T where T: Decodable {
//        guard let url = URL(string: endPoint.baseUrl + endPoint.path)else { throw URLError(.badURL) }
//     
//        var request = URLRequest(url: url)
//        request.httpMethod = endPoint.method.uppercased()
//        
//        let (data, _) = try await URLSession.shared.data(for: request)
//         return try JSONDecoder().decode(T.self, from: data)
//    }
//

        func request<T: Decodable, U: Encodable>(
            endPoint: EndPoint,
            body: U? = nil
        ) async throws -> T {

            guard let url = URL(string: endPoint.baseUrl + endPoint.path) else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)
            request.httpMethod = endPoint.method.uppercased()

            if let body {
                request.httpBody = try JSONEncoder().encode(body)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            if let httpResponse = request as? HTTPURLResponse {
                print("Status Code:", httpResponse.statusCode)
            }

            print(request.url!)
            print(request.httpMethod!)
            print(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")
            print(request.allHTTPHeaderFields ?? [:])

            let (data, _) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
