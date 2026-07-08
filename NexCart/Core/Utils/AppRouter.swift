//
//  AppRouter.swift
//  NexCart
//
//  Created by Mohamed Magdy on 08/07/2026.
//

import Foundation

final class AppRouter: ObservableObject {
    static let shared = AppRouter()

    @Published var selectedTab = 0
}
