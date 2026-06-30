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
            var fetchedBrands = try await fetchBrandsUseCase.execute()
            let allBrand = BrandEntity(id: "all", name: "All", imageURL: "https://cdn-icons-png.flaticon.com/512/565/565547.png")
            fetchedBrands.insert(allBrand, at: 0)
            brands = fetchedBrands
        } catch {
            #if DEBUG
            print("FetchBrandsUseCase failed: \(error)")
            #endif
            errorMessage = "Couldn't load brands. Pull to refresh."
        }
        isLoading = false
    }
}
