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
    var ApiToken : String { get }
    var body: Data? {get}
}


//MARK: Example on how can we use this protocol
//MARK: This will contain all the endPointes for each feathcer 

//enum ProductsEndPoints: EndPoint{
//    
//    case allProducts
//    case getProductByID(productID: Int)
//    case productsByBrand(brandName: String)
//    case getNumberOfProducts(numsOfProducts: Int)
//    
//    
//    var baseUrl: String {
//        return "https://mad46-ios-team9.myshopify.com/admin/api/2024-01"
//    }
//    
//    var path: String{
//        switch self {
//        case .allProducts:
//            return "/products.json"
//        case .getProductByID(let productID):
//            return ""
//        case .productsByBrand(let brandName):
//            return ""
//        case .getNumberOfProducts(let numsOfProducts):
//            return ""
//        }
//    }
 
//    var method: String{
//        return "GET"
//    }
//}
// 
extension EndPoint {
    var ApiToken : String {
        "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"
    }
}
