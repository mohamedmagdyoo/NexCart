//
//  generate.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

protocol AIProvider {
    func generate(request: OutfitRequest) async throws -> GeneratedOutfit
}
