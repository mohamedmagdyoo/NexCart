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
            if brandName.lowercased() == "all" {
                return "/products.json?limit=250"
            }
            let vendor = brandName.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            let encoded = vendor.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? vendor
            return "/products.json?vendor=\(encoded)&limit=250"
        }
    }

    var method: String {
        "GET"
    }
    var body: Data?{
        return nil
    }
}
