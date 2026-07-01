//
//  CoreData.swift
//  NexCart
//
//  Created by shady ramadan on 29/06/2026.


import CoreData
import Foundation

final class CoreDataService {
    static let shared = CoreDataService()
    
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "NexCart")
        container.loadPersistentStores { _, error in
            if let error = error {
                print("⚠️ Core Data failure: \(error.localizedDescription)")
            }
        }
    }
    
       func saveProductToDatabase(product: ProductEntity) {
        let context = container.viewContext
        
             let cachedProduct = NSEntityDescription.insertNewObject(forEntityName: "NexCartProduct", into: context)
        
        cachedProduct.setValue(product.id, forKey: "id")
        cachedProduct.setValue(product.name, forKey: "name")
        cachedProduct.setValue(product.brand, forKey: "brand")
        cachedProduct.setValue(product.price, forKey: "price")
        cachedProduct.setValue(product.imageURL, forKey: "imageURL")
        
        do {
            try context.save()
            print("✅ Product \(product.name) saved to Core Data safely!")
        } catch {
            print("❌ Failed to save product to Core Data: \(error.localizedDescription)")
        }
    }
    
    func deleteProductFromDatabase(id: Int) {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NexCartProduct")
        fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            try context.save()
            print("🗑️ Product \(id) removed from Core Data!")
        } catch {
            print("❌ Failed to delete product: \(error.localizedDescription)")
        }
    }
    
    func isFavorite(id: Int) -> Bool {
        let context = container.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NexCartProduct")
        fetchRequest.predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        
        do {
            let count = try context.count(for: fetchRequest)
            return count > 0
        } catch {
            return false
        }
    }
    
//    func fetchFavoriteProducts() -> [ProductEntity] {
//        let context = container.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "NexCartProduct")
//        
//        do {
//            let results = try context.fetch(fetchRequest)
//            return results.compactMap { object in
//                guard let id = object.value(forKey: "id") as? Int,
//                      let name = object.value(forKey: "name") as? String else {
//                    return nil
//                }
//                
//                let brand = object.value(forKey: "brand") as? String ?? ""
//                let price = object.value(forKey: "price") as? Double ?? 0.0
//                let imageURL = object.value(forKey: "imageURL") as? String ?? ""
//                
//                return ProductEntity(id: id, name: name, imageURL: imageURL, price: price, originalPrice: nil, isFavorited: true, brand: brand)
//            }
//        } catch {
//            print("❌ Failed to fetch favorites: \(error.localizedDescription)")
//            return []
//        }
//    }
}
