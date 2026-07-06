//
//  SavedOutfitRepositoryProtocol.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

protocol SavedOutfitRepositoryProtocol {
    func save(_ outfit: GeneratedOutfit) async throws
    func delete(id: String) async throws
    func getSaved() async throws -> [GeneratedOutfit]
    func clear() async throws
}
