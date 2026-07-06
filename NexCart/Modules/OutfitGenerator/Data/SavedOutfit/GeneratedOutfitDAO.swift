//
//  GeneratedOutfitDAO.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation
import CoreData

protocol GeneratedOutfitDAOProtocol {
    func insert(_ outfit: GeneratedOutfit) throws
    func delete(id: String) throws
    func fetchAll() throws -> [GeneratedOutfit]
    func deleteAll() throws
}

final class GeneratedOutfitDAO: GeneratedOutfitDAOProtocol {
    private let container: NSPersistentContainer
    private var context: NSManagedObjectContext {
        return container.viewContext
    }

    init() {
        container = NSPersistentContainer(name: "NexCart")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("⚠️ Core Data failure: \(error.localizedDescription)")
            }
        }
    }

    func insert(_ outfit: GeneratedOutfit) throws {
        let entity = GeneratedOutfitEntity(context: context)
        entity.id = outfit.id
        entity.imageData = outfit.imageData
        entity.generatedAt = outfit.generatedAt

        try context.save()
    }

    func delete(id: String) throws {
        let request: NSFetchRequest<GeneratedOutfitEntity> = GeneratedOutfitEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)

        let results = try context.fetch(request)
        results.forEach { context.delete($0) }
        try context.save()
    }

    func fetchAll() throws -> [GeneratedOutfit] {
        let request: NSFetchRequest<GeneratedOutfitEntity> = GeneratedOutfitEntity.fetchRequest()
        let entities = try context.fetch(request)
        return entities.map { $0.toDomain() }
    }

    func deleteAll() throws {
        let request: NSFetchRequest<GeneratedOutfitEntity> = GeneratedOutfitEntity.fetchRequest()
        let results = try context.fetch(request)
        results.forEach { context.delete($0) }
        try context.save()
    }
}
