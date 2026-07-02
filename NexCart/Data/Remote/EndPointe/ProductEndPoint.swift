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
    case addCart
    case customCollections
    case productsByCollection(collectionId: String)
    
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
            return "/products.json?limit=\(limit)&status=active"
        case .shopMetafields:
            return "/shop/metafields.json"
        case .allBrands:
            return "/smart_collections.json"
        case .addCart:
            return "/draft_orders.json"
        case .customCollections:
            return "/custom_collections.json"
        case .productsByCollection(let collectionId):
            return "/products.json?collection_id=\(collectionId)"
        }
    }
    
    var method: String {
        switch self {
        case .addCart:
            return "POST"
            
        default:
            return "GET"
        }
    }
}
