//
//  AIProvidersType.swift
//  NexCart
//
//  Created by shady ramadan on 07/07/2026.
//

import Foundation

enum AIProviderType: String, CaseIterable, Identifiable {
    case pollinations = "Pollinations"
    case huggingFace  = "HuggingFace"
 
    var id: String { rawValue }
 
    var description: String {
        switch self {
        case .pollinations: return "Fast & Free"
        case .huggingFace:  return "High Quality"
        }
    }
 
    var iconName: String {
        switch self {
        case .pollinations: return "bolt.fill"
        case .huggingFace:  return "sparkles"
        }
    }
 
    func makeProvider() -> AIProvider {
        switch self {
        case.pollinations: return PollinationsProvider()
        case .huggingFace:
            let imageDownloadService = ImageDownloadService()
            return HuggingFaceProvider(
                service: HuggingFaceService(imageDownloadService: imageDownloadService),
                imageDownloadService: imageDownloadService,
                imageCompositionService: ImageCompositionService()
            )
        }
    }
}
