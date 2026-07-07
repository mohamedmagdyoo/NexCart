//
//  OutfitSelectionRepositoryProtocol.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

protocol OutfitSelectionRepositoryProtocol {
    func add(_ product: SelectedProduct) async throws
    func remove(productID: Int) async
    func getAll() async -> [SelectedProduct]
    func clear() async
}
