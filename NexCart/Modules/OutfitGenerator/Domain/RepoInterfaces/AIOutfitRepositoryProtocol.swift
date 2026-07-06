//
//  AIOutfitRepositoryProtocol.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

protocol AIOutfitRepositoryProtocol {
    func generate(request: OutfitRequest) async throws -> GeneratedOutfit
}
