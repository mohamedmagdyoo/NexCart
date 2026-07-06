//
//  SavedOutfitsViewModel.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

@MainActor
final class SavedOutfitsViewModel: ObservableObject {
    @Published var savedOutfits: [GeneratedOutfit] = []

    private let getSavedOutfitsUseCase: GetSavedOutfitsUseCaseProtocol
    private let deleteSavedOutfitUseCase: DeleteSavedOutfitUseCaseProtocol

    init(
        getSavedOutfitsUseCase: GetSavedOutfitsUseCaseProtocol,
        deleteSavedOutfitUseCase: DeleteSavedOutfitUseCaseProtocol
    ) {
        self.getSavedOutfitsUseCase = getSavedOutfitsUseCase
        self.deleteSavedOutfitUseCase = deleteSavedOutfitUseCase
    }

    func loadSavedOutfits() async {
        savedOutfits = (try? await getSavedOutfitsUseCase.execute()) ?? []
    }

    func delete(id: String) async {
        try? await deleteSavedOutfitUseCase.execute(id: id)
        await loadSavedOutfits()
    }
}
