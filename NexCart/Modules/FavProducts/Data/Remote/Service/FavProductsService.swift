//
//  FavProductsService.swift
//  NexCart
//
//  Created by Mohamed Magdy on 02/07/2026.
//

import Foundation
import FirebaseFirestore

protocol FavProductsRemoteServiceProtocol {
    func addFavorite(favProduct: FavProduct, userId: String) async throws
    func removeFavorite(productId: Int, userId: String) async throws
    func fetchFavoriteIds(userId: String) async throws -> [Int]
    func fetchFavoriteProducts(userId: String) async throws -> [FavProduct]
}

final class FavProductsFirestoreService: FavProductsRemoteServiceProtocol {
    private let db = Firestore.firestore()

    private func favoritesRef(for userId: String) -> CollectionReference {
        db.collection("users").document(userId).collection("favProducts")
    }

    func addFavorite(favProduct: FavProduct, userId: String) async throws {
        let data: [String: Any] = [
            "productId": favProduct.id,
            "addedAt": Timestamp(date: Date()),
            "brand": favProduct.brand,
            "name": favProduct.name,
            "price": favProduct.price,
            "imageURL": favProduct.imageURL
        ]
        try await favoritesRef(for: userId)
            .document(String(favProduct.id))   // Firestore doc IDs must be String
            .setData(data)
        print("Saved To Firstore success")
    }

    func removeFavorite(productId: Int, userId: String) async throws {
        try await favoritesRef(for: userId)
            .document(String(productId))
            .delete()
    }

    func fetchFavoriteIds(userId: String) async throws -> [Int] {
        let snapshot = try await favoritesRef(for: userId).getDocuments()
        // Read from the stored field rather than parsing documentID,
        // since the field is the real typed source of truth.
        return snapshot.documents.compactMap { $0.data()["productId"] as? Int }
    }

    func fetchFavoriteProducts(userId: String) async throws -> [FavProduct] {
        let snapshot = try await favoritesRef(for: userId).getDocuments()

        return snapshot.documents.compactMap { document in
            let data = document.data()

            guard let id = data["productId"] as? Int,
                  let brand = data["brand"] as? String,
                  let name = data["name"] as? String,
                  let price = data["price"] as? Double,
                  let imageURL = data["imageURL"] as? String else {
                print("⚠️ Skipping malformed favorite document: \(document.documentID)")
                return nil
            }

            return FavProduct(
                id: id,
                brand: brand,
                name: name,
                price: price,
                imageURL: imageURL
            )
        }
    }
}
