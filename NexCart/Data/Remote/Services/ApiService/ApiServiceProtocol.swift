//
//  ApiServiceProtocol.swift
//  MVVM+CleanArch
//
//  Created by Mohamed Magdy on 11/05/2026.
//

import Foundation

protocol ApiServiceProtocol {
    func request<T: Decodable, U: Encodable>(
        endPoint: EndPoint,
        body: U?
    ) async throws -> T
}
