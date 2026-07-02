//
//  CollectionsListViewModel.swift
//  NexCart
//
//  Created by Shady Ramadan on 02/07/2026.
//

import Foundation

@MainActor
final class CollectionsListViewModel: ObservableObject {
    @Published var collections: [CustomCollectionEntity] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let hiddenCollectionTitles: Set<String> = ["home page", "hydrogen"]

    private let fetchCollectionsUseCase: FetchCollectionsUseCaseProtocol

    init(fetchCollectionsUseCase: FetchCollectionsUseCaseProtocol) {
        self.fetchCollectionsUseCase = fetchCollectionsUseCase
    }

    func loadCollections() async {
        isLoading = true
        errorMessage = nil
        do {
            var fetchedCollections = try await fetchCollectionsUseCase.execute()

            fetchedCollections.removeAll { collection in
                hiddenCollectionTitles.contains(collection.title.lowercased())
            }

            let allCollection = CustomCollectionEntity(
                id: "all",
                title: "All",
                imageURL: ""
            )
            fetchedCollections.insert(allCollection, at: 0)
            collections = fetchedCollections
        } catch {
            #if DEBUG
            print("FetchCollectionsUseCase failed: \(error)")
            #endif
            errorMessage = "Couldn't load collections. Pull to refresh."
        }
        isLoading = false
    }
}
