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
        
             let cachedProduct = NSEntityDescription.insertNewObject(forEntityName: "NextCartModel", into: context)
        
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
}
