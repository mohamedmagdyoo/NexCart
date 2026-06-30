//
//  BrandProductsEndPoint.swift
//  NexCart
//
//  Created by shady ramadan on 30/06/2026.
//

import Foundation

enum BrandProductsEndPoint: EndPoint {
    case productsByCollection(collectionId: String, brandName: String)

    var baseUrl: String {
        "https://mad46-ios-team9.myshopify.com/admin/api/2024-01"
    }

    var path: String {
        switch self {
        case .productsByCollection(let collectionId, let brandName):
            // Fallback to vendor filtering if collection rules are incomplete.
            // Shopify is case-sensitive for vendor. If Smart Collection title is "ADIDAS", 
            // the vendor on products might be "Adidas". 
            // We'll use the capitalized version for the vendor query.
            let vendor = brandName.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
            let encoded = vendor.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? vendor
            return "/products.json?vendor=\(encoded)&limit=250"
        }
    }

    var method: String {
        "GET"
    }
}
