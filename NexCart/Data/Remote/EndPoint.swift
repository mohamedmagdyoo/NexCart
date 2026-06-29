//
//  EndPoint.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation

protocol EndPoint{
    var baseUrl: String {get}
    var path: String {get}
    var method: String{get}
}


//MARK: Example on how can we use this protocol
//MARK: This will contain all the endPointes for each feathcer 

enum ProductsEndPoints: EndPoint {

    case allProducts
    case getProductByID(productID: Int)
    case productsByBrand(brandName: String)
    case getNumberOfProducts(numsOfProducts: Int)
    case addToCart

    var baseUrl: String {
        "https://mad46-ios-team9.myshopify.com/admin/api/2024-01"
    }

    var path: String {
        switch self {
        case .allProducts:
            return "/products.json"

        case .addToCart:
            return "/draft_orders.json"

        case .getProductByID:
            return ""

        case .productsByBrand:
            return ""

        case .getNumberOfProducts:
            return ""
        }
    }

    var method: String {
        switch self {
        case .addToCart:
            return "POST"

        default:
            return "GET"
        }
    }
}
 

