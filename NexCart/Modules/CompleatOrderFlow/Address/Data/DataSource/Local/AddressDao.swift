//
//  AddressDao.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import CoreData
import Foundation

protocol AddressDao {
    func insert(_ address: AddressEntity) throws
    func update(_ address: AddressEntity) throws
    func fetchAll(ownerID: String) throws -> [AddressEntity]
    func fetchDefault(ownerID: String) throws -> AddressEntity?
    func fetchById(_ id: String) throws -> AddressEntity?
    func delete(id: String) throws
    func deleteAll() throws
}

final class CoreDataAddressDao: AddressDao {
    private let container: NSPersistentContainer

    
    

    init() {
        
        container = NSPersistentContainer(name: "NexCart")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("⚠️ Core Data failure: \(error.localizedDescription)")
            }
        }
    }

    func insert(_ address: AddressEntity) throws {
        let context = container.viewContext

        var address = address

        let defaultAddress = try fetchDefault(ownerID: address.ownerUserId)

        if defaultAddress == nil {
            address.isDefault = true
        }

        let managedObject = AddressMO(context: context)
        map(address, into: managedObject)
        try saveContext()
    }

    func update(_ address: AddressEntity) throws {
        let context = container.viewContext

        let request: NSFetchRequest<AddressMO> = AddressMO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", address.id)
        request.fetchLimit = 1

        guard let managedObject = try context.fetch(request).first else {
            throw AddressError.addressNotFound(id: address.id)
        }

        map(address, into: managedObject)
        try saveContext()
    }

    func fetchAll(ownerID: String) throws -> [AddressEntity] {
        let context = container.viewContext

        let request: NSFetchRequest<AddressMO> = AddressMO.fetchRequest()
        
        request.predicate = NSPredicate(format: "ownerUserId == %@", ownerID)
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "updatedAt", ascending: false)
        ]

        do {

            return try context.fetch(request).map(map)
        } catch {
            throw AddressError.localStorageFailed(
                underlying: error.localizedDescription
            )
        }
    }
    func fetchDefault(ownerID: String) throws -> AddressEntity? {
        let context = container.viewContext

        let request: NSFetchRequest<AddressMO> = AddressMO.fetchRequest()
        
        request.predicate = NSPredicate(
            format: "isDefault == YES AND ownerUserId == %@",
            ownerID
        )
        
        request.fetchLimit = 1

        do {
            return try context.fetch(request).first.map(map)
        } catch {
            throw AddressError.localStorageFailed(underlying: error.localizedDescription)
        }
    }

    func fetchById(_ id: String) throws -> AddressEntity? {
        let context = container.viewContext

        let request: NSFetchRequest<AddressMO> = AddressMO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1

        do {
            return try context.fetch(request).first.map(map)
        } catch {
            throw AddressError.localStorageFailed(underlying: error.localizedDescription)
        }
    }

    func delete(id: String) throws {
        let context = container.viewContext

        let request: NSFetchRequest<AddressMO> = AddressMO.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1

        guard let managedObject = try context.fetch(request).first else {
            throw AddressError.addressNotFound(id: id)
        }

        context.delete(managedObject)
        try saveContext()
    }

    func deleteAll() throws {
        let context = container.viewContext

        let request: NSFetchRequest<NSFetchRequestResult> = AddressMO.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            try context.execute(deleteRequest)
            try saveContext()
        } catch {
            throw AddressError.localStorageFailed(underlying: error.localizedDescription)
        }
    }

    private func saveContext() throws {
        let context = container.viewContext

        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            throw AddressError.localStorageFailed(underlying: error.localizedDescription)
        }
    }

    private func map(_ entity: AddressEntity, into managedObject: AddressMO) {
        managedObject.id = entity.id
        managedObject.fullName = entity.fullName
        managedObject.streetAddress = entity.streetAddress
        managedObject.city = entity.city
        managedObject.state = entity.state
        managedObject.zip = entity.zip
        managedObject.label = entity.label
        managedObject.isDefault = entity.isDefault
        managedObject.ownerUserId = entity.ownerUserId
        managedObject.updatedAt = entity.updatedAt
    }

    private func map(_ managedObject: AddressMO) -> AddressEntity {
        AddressEntity(
            id: managedObject.id ?? UUID().uuidString,
            fullName: managedObject.fullName ?? "",
            streetAddress: managedObject.streetAddress ?? "",
            city: managedObject.city ?? "",
            state: managedObject.state ?? "",
            zip: managedObject.zip ?? "",
            label: managedObject.label,
            isDefault: managedObject.isDefault,
            ownerUserId: managedObject.ownerUserId ?? "",
            updatedAt: managedObject.updatedAt ?? Date()
        )
    }
}
