//
//  CollectionsRepoProtocol.swift
//  NexCart
//
//  Created by shady ramadan on 02/07/2026.
//

import Foundation
protocol CollectionsRepoProtocol {
    func fetchCollections() async throws -> [CustomCollectionEntity]
    func fetchProducts(forCollectionId collectionId: String) async throws -> [ProductEntity]
}
