//
//  BrandsEndPoint.swift
//  NexCart
//
//  Created by shady ramadan on 30/06/2026.
//

import Foundation

enum BrandsEndPoint: EndPoint {
    case allBrands

    var baseUrl: String {
        "https://mad46-ios-team9.myshopify.com/admin/api/2024-01"
    }

    var path: String {
        switch self {
        case .allBrands:
            return "/smart_collections.json"
        }
    }

    var method: String {
        "GET"
    }
}
