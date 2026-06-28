//
//  ApiServiceProtocol.swift
//  MVVM+CleanArch
//
//  Created by Mohamed Magdy on 11/05/2026.
//

import Foundation

protocol ApiServiceProtocol{
    func fetch<T: Decodable>(endPoint: EndPoint) async throws -> T
}
