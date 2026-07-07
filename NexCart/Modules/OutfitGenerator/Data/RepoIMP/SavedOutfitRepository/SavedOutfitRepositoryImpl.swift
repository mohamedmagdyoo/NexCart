//
//  SavedOutfitRepositoryImpl.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation


final class SavedOutfitRepositoryImpl: SavedOutfitRepositoryProtocol {
    private let dao: GeneratedOutfitDAOProtocol

    init(dao: GeneratedOutfitDAOProtocol) {
        self.dao = dao
    }

    func save(_ outfit: GeneratedOutfit) async throws {
        try dao.insert(outfit)
    }

    func delete(id: String) async throws {
        try dao.delete(id: id)
    }

    func getSaved() async throws -> [GeneratedOutfit] {
        try dao.fetchAll()
    }

    func clear() async throws {
        try dao.deleteAll()
    }
}

extension GeneratedOutfitEntity {
    func toDomain() -> GeneratedOutfit {
        GeneratedOutfit(
            id: id!,
            imageData: imageData!,
            generatedAt: generatedAt!,
            name: name
        )
    }
}
