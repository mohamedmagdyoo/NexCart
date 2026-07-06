//
//  RemoveProductFromSelectionUseCase.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

protocol RemoveProductFromSelectionUseCaseProtocol {
    func execute(productID: Int) async
}

final class RemoveProductFromSelectionUseCase: RemoveProductFromSelectionUseCaseProtocol {
    private let repository: OutfitSelectionRepositoryProtocol

    init(repository: OutfitSelectionRepositoryProtocol) {
        self.repository = repository
    }

    func execute(productID: Int) async {
        await repository.remove(productID: productID)
    }
}
