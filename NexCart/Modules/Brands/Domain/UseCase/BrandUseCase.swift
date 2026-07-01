//
//  BrandUseCase.swift
//  NexCart
//
//  Created by shady ramadan on 30/06/2026.
//

import Foundation


protocol FetchBrandsUseCaseProtocol {
    func execute() async throws -> [BrandEntity]
}

final class FetchBrandsUseCase: FetchBrandsUseCaseProtocol {
    private let repo: BrandsRepoProtocol

    init(repo: BrandsRepoProtocol) {
        self.repo = repo
    }

    func execute() async throws -> [BrandEntity] {
        try await repo.fetchBrands()
    }
}
