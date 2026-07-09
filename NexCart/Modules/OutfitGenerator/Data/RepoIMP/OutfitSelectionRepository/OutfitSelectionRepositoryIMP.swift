//
//  OutfitSelectionRepositoryIMP.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

final class OutfitSelectionRepositoryImpl: OutfitSelectionRepositoryProtocol {
    private let dao: SelectedProductDAOProtocol
    private let maxSelectionLimit = 4

    init(dao: SelectedProductDAOProtocol) {
        self.dao = dao
    }

    func add(_ product: SelectedProduct) async throws {
        let currentCount = try dao.count()
        guard currentCount < maxSelectionLimit else {
            throw SelectionError.maximumReached
        }
        try dao.insert(product)
    }

    func remove(productID: Int) async {
        try? dao.delete(productID: productID)
    }

    func getAll() async -> [SelectedProduct] {
        (try? dao.fetchAll()) ?? []
    }

    func clear() async {
        try? dao.deleteAll()
    }
}
