//
//  SelectedProductDAO.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation
import CoreData

protocol SelectedProductDAOProtocol {
    func insert(_ product: SelectedProduct) throws
    func delete(productID: Int) throws
    func fetchAll() throws -> [SelectedProduct]
    func deleteAll() throws
    func count() throws -> Int
}

final class SelectedProductDAO: SelectedProductDAOProtocol {
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

    func insert(_ product: SelectedProduct) throws {
        let entity = SelectedProductEntity(context: context)
        entity.id = Int64(product.id)
        entity.title = product.title
        entity.imageURL = product.imageURL
        entity.category = product.category
        entity.color = product.color
        entity.brand = product.brand

        try context.save()
    }

    func delete(productID: Int) throws {
        let request: NSFetchRequest<SelectedProductEntity> = SelectedProductEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", NSNumber(value: productID))

        let results = try context.fetch(request)
        results.forEach { context.delete($0) }
        try context.save()
    }

    func fetchAll() throws -> [SelectedProduct] {
        let request: NSFetchRequest<SelectedProductEntity> = SelectedProductEntity.fetchRequest()
        let entities = try context.fetch(request)
        return entities.map { $0.toDomain() }
    }

    func deleteAll() throws {
        let request: NSFetchRequest<SelectedProductEntity> = SelectedProductEntity.fetchRequest()
        let results = try context.fetch(request)
        results.forEach { context.delete($0) }
        try context.save()
    }

    func count() throws -> Int {
        let request: NSFetchRequest<SelectedProductEntity> = SelectedProductEntity.fetchRequest()
        return try context.count(for: request)
    }
}

extension SelectedProductEntity {
    func toDomain() -> SelectedProduct {
        SelectedProduct(
            id: Int(id),
            title: title!,
            imageURL: imageURL!,
            category: category,
            color: color,
            brand: brand
        )
    }
}
