//
//  HuggingFaceServiceError.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

enum HuggingFaceServiceError: Error {
    case invalidAPIKey
    case modelLoading(estimatedSeconds: Double?)
    case requestFailed(statusCode: Int)
    case invalidResponse
    case decodingFailed
}
