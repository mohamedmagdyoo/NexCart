//
//  BrandProductsEndPoint.swift
//  NexCart
//
//  Created by shady ramadan on 30/06/2026.
//

import Foundation

enum BrandProductsEndPoint: EndPoint {
    case allProducts

    var baseUrl: String {
        "https://mad46-ios-team9.myshopify.com/admin/api/2024-01"
    }

    var path: String {
        switch self {
        case .allProducts:
            return "/products.json?limit=250"
        }
    }

    var method: String {
        "GET"
    }
}
