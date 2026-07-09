//
//  SearchEndPoint.swift
//  NexCart
//
//  Created by shady ramadan on 03/07/2026.
//

import Foundation
 
enum SearchEndPoint: EndPoint {
    var body: Data?{
        return nil
    }
    
 
    case allProducts
 
    var baseUrl: String {
        "https://mad46-ios-team9.myshopify.com/admin/api/2024-01"
    }
 
    var path: String {
        "/products.json?limit=250"
    }
 
    var method: String { "GET" }
}
