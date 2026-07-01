//
//  BrandListViewModel.swift
//  NexCart
//
//  Created by shady ramadan on 30/06/2026.
//

import Foundation

final class BrandsListViewModel: ObservableObject {
    @Published var brands: [BrandEntity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let fetchBrandsUseCase: FetchBrandsUseCaseProtocol

    init(fetchBrandsUseCase: FetchBrandsUseCaseProtocol) {
        self.fetchBrandsUseCase = fetchBrandsUseCase
    }

    func loadBrands() async {
        isLoading = true
        errorMessage = nil
        do {
            brands = try await fetchBrandsUseCase.execute()
        } catch {
            #if DEBUG
            print("FetchBrandsUseCase failed: \(error)")
            #endif
            errorMessage = "Couldn't load brands. Pull to refresh."
        }
        isLoading = false
    }
}
