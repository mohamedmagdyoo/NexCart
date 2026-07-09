//
//  AppConfiguration.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import Foundation

enum AppConfiguration {
    static var huggingFaceToken: String {
        guard let token = Bundle.main.object(
            forInfoDictionaryKey: "HUGGING_FACE_TOKEN"
        ) as? String else {
            fatalError("HUGGING_FACE_TOKEN not found")
        }

        return token
    }
}
