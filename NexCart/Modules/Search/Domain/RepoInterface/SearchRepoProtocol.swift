//
//  SearchRepoProtocol.swift
//  NexCart
//
//  Created by shady ramadan on 03/07/2026.
//

import Foundation
 
protocol SearchRepoProtocol {
    func fetchAllProducts() async throws -> [ProductEntity]
}
