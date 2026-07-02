//
//  CartEndPoint.swift
//  NexCart
//
//  Created by Antoneos Philip on 01/07/2026.
//

import Foundation
enum CartEndPoint: EndPoint {
    case allCart

    var baseUrl: String {
        "https://mad46-ios-team9.myshopify.com/admin/api/2024-01"
    }

    var path: String {
        switch self {
        case .allCart:
            return "/draft_orders.json"
    
        }
    }

    var method: String {
        "GET"
    }
}
