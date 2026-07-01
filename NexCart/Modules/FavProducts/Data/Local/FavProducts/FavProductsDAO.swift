//
//  FavProductsDAO.swift
//  NexCart
//
//  Created by shady ramadan on 29/06/2026.
//

import CoreData
import Foundation

enum FavDaoError: LocalizedError {
    case saveFailed
    case fetchFailed
    case deleteFailed
    case productAlreadyHere
    case productNotFound

    var errorDescription: String? {
        switch self {
        case .saveFailed:
            return "Failed to save product to favorites"
        case .fetchFailed:
            return "Failed to fetch favorite products"
        case .deleteFailed:
            return "Failed to remove product from favorites"
        case .productNotFound:
            return "Product not found in favorites"
        case .productAlreadyHere:
            return "Product already in favorites"
        }
    }
}

// MARK: - DAO
final class FavProductsDAO: FavProductsDaoProtocol {
    static let shared = FavProductsDAO()

    let container: NSPersistentContainer

    private init() {
        container = NSPersistentContainer(name: "NexCart")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("⚠️ Core Data failure: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Add
    func addToFav(product: ProductEntity) throws {
        let context = container.viewContext

        // Avoid duplicate entries
        if isFav(productId: product.id) {
            throw FavDaoError.productAlreadyHere
        }

        let cachedProduct = NSEntityDescription.insertNewObject(forEntityName: "NexCartProduct", into: context)

        cachedProduct.setValue(product.id, forKey: "id")
        cachedProduct.setValue(product.name, forKey: "name")
        cachedProduct.setValue(product.brand, forKey: "brand")
        cachedProduct.setValue(product.price, forKey: "price")
        cachedProduct.setValue(product.imageURL, forKey: "imageURL")

        do {
            try context.save()
            print("✅ Product \(product.name) added to favorites!")
        } catch {
            context.rollback() // discard the half-inserted object on failure
            throw FavDaoError.saveFailed
        }
    }

    // MARK: - Remove
    func removeFromFav(productId: Int) throws {
        let context = container.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "NexCartProduct")
        // NSNumber(value:) avoids the %d/%@ format-specifier crash seen earlier
        // (passing a non-object value through %@, or a non-Int32 value through %d, corrupts the predicate).
        request.predicate = NSPredicate(format: "id == %@", NSNumber(value: productId))
        request.fetchLimit = 1

        do {
            let results = try context.fetch(request)
            guard let objectToDelete = results.first else {
                throw FavDaoError.productNotFound
            }
            context.delete(objectToDelete)
            try context.save()
            print("🗑️ Product \(productId) removed from favorites!")
        } catch let error as FavDaoError {
            throw error
        } catch {
            throw FavDaoError.deleteFailed
        }
    }

    // MARK: - Get All
    func getAllFav() throws -> [FavProduct] {
        let context = container.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "NexCartProduct")

        do {
            let results = try context.fetch(request)
            return try results.compactMap { object in
                guard let id = object.value(forKey: "id") as? Int,
                      let name = object.value(forKey: "name") as? String,
                      let brand = object.value(forKey: "brand") as? String,
                      let price = object.value(forKey: "price") as? Double,
                      let imageURL = object.value(forKey: "imageURL") as? String else {
                    throw FavDaoError.fetchFailed
                }

                return FavProduct(id: id, brand: brand, name: name, price: price, imageURL: imageURL)
            }
        } catch {
            throw FavDaoError.fetchFailed
        }
    }

    // MARK: - Check existence
    func isFav(productId: Int) -> Bool {
        let context = container.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "NexCartProduct")
        request.predicate = NSPredicate(format: "id == %@", NSNumber(value: productId))
        request.fetchLimit = 1

        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }

    // MARK: - Clean
    func cleanFavTable() throws {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NexCartProduct")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        do {
            let result = try context.execute(deleteRequest) as? NSBatchDeleteResult
            if let objectIDs = result?.result as? [NSManagedObjectID] {
                NSManagedObjectContext.mergeChanges(
                    fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs],
                    into: [context]
                )
            }
            print("🧹 Favorites table cleared!")
        } catch {
            throw FavDaoError.deleteFailed
        }
    }
}
