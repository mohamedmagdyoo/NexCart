//
//  FavProductRepo.swift
//  NexCart
//
//  Created by Mohamed Magdy on 02/07/2026.
//

import Foundation


final class FavProductsRepository: FavProductRepoInterface {

    private let favDao: FavProductsDaoProtocol
    private let favService: FavProductsRemoteServiceProtocol

    init(
        localDao: FavProductsDaoProtocol,
        remoteService: FavProductsRemoteServiceProtocol
    ) {
        self.favDao = localDao
        self.favService = remoteService
    }

    // MARK: - Shared helper: current signed-in user's id
    private func getCurrentUserId() -> String? {
        guard let userData = UserDefaults.standard.data(forKey: "userEntity"),
              let userEntity = try? JSONDecoder().decode(UserEntity.self, from: userData) else {
            return nil
        }
        return userEntity.id
    }

    // MARK: - Add (local first, then remote — rollback local if remote fails)
    func addFavorite(product: FavProduct) async throws {
        try favDao.addToFav(product: product)

        guard let userId = getCurrentUserId() else {
            // No signed-in user — local-only favorite, nothing to sync yet.
            return
        }

        do {
            try await favService.addFavorite(favProduct: product, userId: userId)
        } catch {
            // Remote failed — roll back local so both sides stay consistent.
            try? favDao.removeFromFav(productId: product.id)
            throw error
        }
    }

    // MARK: - Remove (local first, then remote)
    func removeFavorite(productId: Int) async throws {
        try favDao.removeFromFav(productId: productId)

        guard let userId = getCurrentUserId() else { return }

        do {
            try await favService.removeFavorite(productId: productId, userId: userId)
        } catch {
            // Local is already removed; remote will self-correct on next syncFromRemote()
            print("⚠️ Remote remove failed for product \(productId): \(error.localizedDescription)")
            throw error
        }
    }

    func getAllFavorites() throws -> [FavProduct] {
        try favDao.getAllFav()
    }

    func isFav(productId: Int) -> Bool {
        favDao.isFav(productId: productId)
    }

    // MARK: - Sync: clear CoreData, pull full favorites from Firestore, reinsert
    func syncFromRemote() async throws {
        guard let userId = getCurrentUserId() else { return }

        // 1. Clear local cache
        try favDao.cleanFavTable()

        // 2. Fetch full favorite products from Firestore (no need to re-fetch from Products API,
        //    since Firestore now stores brand/name/price/imageURL directly)
        let remoteFavProducts = try await favService.fetchFavoriteProducts(userId: userId)

        // 3. Insert them into CoreData
        for remoteFavProduct in remoteFavProducts {
            try favDao.addToFav(product: remoteFavProduct)
        }
    }
    
    func cleanFavTabel() {
        favDao.cleanFavTable()
    }
}
