//
//  CollectionUseCase.swift
//  NexCart
//
//  Created by shady ramadan on 02/07/2026.
//

import Foundation

protocol FetchCollectionsUseCaseProtocol {
    func execute() async throws -> [CustomCollectionEntity]
}
 
final class FetchCollectionsUseCase: FetchCollectionsUseCaseProtocol {
    private let repo: CollectionsRepoProtocol
 
    init(repo: CollectionsRepoProtocol) {
        self.repo = repo
    }
 
    func execute() async throws -> [CustomCollectionEntity] {
        try await repo.fetchCollections()
    }
}
 

 
