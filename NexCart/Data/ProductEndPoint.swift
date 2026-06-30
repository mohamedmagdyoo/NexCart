//
//  HomeEndPoint.swift
//  NexCart
//

import Foundation

enum ProductEndPoint: EndPoint {

    case allProducts
    case productsByBrand(brandName: String)
    case productByID(productID: Int)
    case products(limit: Int)
    case shopMetafields
    case allBrands
    
    var baseUrl: String {
        "https://mad46-ios-team9.myshopify.com/admin/api/2024-01"
    }

    var path: String {
        switch self {
        case .allProducts:
            return "/products.json"
        case .productsByBrand(let brand):
            let trimmed = brand.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? trimmed
            return "/products.json?vendor=\(encoded)"
        case .productByID(let id):
            return "/products/\(id).json"
        case .products(let limit):
            return "/products.json?limit=\(limit)"
        case .shopMetafields:
            return "/shop/metafields.json"
        case .allBrands:
            return "/smart_collections.json"
        }
    }

    var method: String { "GET" }
}
