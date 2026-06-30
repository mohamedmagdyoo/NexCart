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
        guard let url = URL(string: endPoint.baseUrl + endPoint.path)else { throw URLError(.badURL) }
     
        var request = URLRequest(url: url)
              request.httpMethod = endPoint.method.uppercased()
              request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(endPoint.ApiToken, forHTTPHeaderField: "X-Shopify-Access-Token")
       
        let (data, response) = try await URLSession.shared.data(for: request)
       
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw URLError(.badServerResponse,
                           userInfo: [NSLocalizedDescriptionKey: "HTTP \(code)"])
        }
       
              return try JSONDecoder().decode(T.self, from: data)
          }
    
}
