//
//  ShardViews.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import SwiftUI

enum ScreenState {
    case idle
    case loading
    case success
    case error(error: String)
}

struct AlertModel: Identifiable {
    var id: UUID = UUID()
    var title: String
    var description: String
}
