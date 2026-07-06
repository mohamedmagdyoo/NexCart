//
//  ClearSelectionUseCase.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

protocol ClearSelectionUseCaseProtocol {
    func execute() async
}

final class ClearSelectionUseCase: ClearSelectionUseCaseProtocol {
    private let repository: OutfitSelectionRepositoryProtocol

    init(repository: OutfitSelectionRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async {
        await repository.clear()
    }
}
