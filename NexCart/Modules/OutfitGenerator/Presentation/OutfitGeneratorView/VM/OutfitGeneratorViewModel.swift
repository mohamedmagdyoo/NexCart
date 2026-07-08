//
//  OutfitGeneratorViewModel.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

enum OutfitGeneratorScreenState {
    case selection
    case loading
    case success(GeneratedOutfit)
    case error(String)
}

@MainActor
final class OutfitGeneratorViewModel: ObservableObject {
    @Published var selectedProducts: [SelectedProduct] = []
    @Published var state: OutfitGeneratorScreenState = .selection
    @Published var showSaveSheet: Bool = false
    @Published var outfitName: String = ""
    @Published var selectedProvider: AIProviderType = .pollinations
    @Published var yourOutOfTokenForToday: String?
    

    private let getSelectedProductsUseCase: GetSelectedProductsUseCaseProtocol
    private let removeProductUseCase: RemoveProductFromSelectionUseCaseProtocol
    private let generateOutfitUseCase: GenerateOutfitUseCaseProtocol
    private let saveGeneratedOutfitUseCase: SaveGeneratedOutfitUseCaseProtocol

    init(
        getSelectedProductsUseCase: GetSelectedProductsUseCaseProtocol,
        removeProductUseCase: RemoveProductFromSelectionUseCaseProtocol,
        generateOutfitUseCase: GenerateOutfitUseCaseProtocol,
        saveGeneratedOutfitUseCase: SaveGeneratedOutfitUseCaseProtocol
    ) {
        self.getSelectedProductsUseCase = getSelectedProductsUseCase
        self.removeProductUseCase = removeProductUseCase
        self.generateOutfitUseCase = generateOutfitUseCase
        self.saveGeneratedOutfitUseCase = saveGeneratedOutfitUseCase
    }

    func loadSelectedProducts() async {
        selectedProducts = await getSelectedProductsUseCase.execute()
    }

    func removeProduct(id: Int) async {
        await removeProductUseCase.execute(productID: id)
        await loadSelectedProducts()
    }

    func generateOutfit() async {
            state = .loading
            let request = OutfitRequest(selectedProducts: selectedProducts)
            let provider = selectedProvider.makeProvider()
            do {
                print("The Request has \(request.selectedProducts.count) Product with \(provider)")
                let outfit = try await generateOutfitUseCase.execute(request: request, provider: provider)
                state = .success(outfit)
            } catch let error as AIError {
                print("From VM")
                print(error.localizedDescription)
                state = .error(message(for: error))
                
            } catch {
                state = .error("Something went wrong. Please try again.")
            }
        }

    func cancelResult() {
        state = .selection
    }

    func beginSave() {
        outfitName = ""
        showSaveSheet = true
    }

    func confirmSave() async {
        guard case .success(var outfit) = state else { return }
        outfit.name = outfitName.trimmingCharacters(in: .whitespacesAndNewlines)
        do {
            try await saveGeneratedOutfitUseCase.execute(outfit: outfit)
            showSaveSheet = false
            state = .selection
        } catch {
            showSaveSheet = false
            state = .error("Couldn't save the outfit. Please try again.")
        }
    }

    private func message(for error: AIError) -> String {
        switch error {
        case .invalidAPIKey: return "AI service authentication failed."
        case .generationFailed: return "Couldn't generate the outfit. Please try again."
        case .invalidResponse: return "Unexpected response from the AI service."
        }
    }
}
