//
//  HuggingFaceEndPoint.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

enum HuggingFaceEndPoint: EndPoint {
    case generateImage(prompt: String, model: String, apiToken: String)

    var baseUrl: String {
        "https://router.huggingface.co/hf-inference/models"
    }

    var path: String {
        switch self {
        case .generateImage(_, let model, _):
            return "/\(model)"
        }
    }

    var method: String {
        switch self {
        case .generateImage:
            return "POST"
        }
    }

    var ApiToken: String {
        switch self {
        case .generateImage(_, _, let apiToken):
            return apiToken
        }
    }

    var body: Data? {
        switch self {
        case .generateImage(let prompt, _, _):
            return try? JSONEncoder().encode(["inputs": prompt])
        }
    }
}
