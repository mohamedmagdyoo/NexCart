//
//  OutfitGeneratorErrors.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

enum SelectionError: Error, Equatable {
    case maximumReached
}

enum AIError: Error, Equatable {
    case invalidAPIKey
    case generationFailed
    case invalidResponse
}
