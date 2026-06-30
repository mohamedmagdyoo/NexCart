//
//  BrandProductsEndPoint.swift
//  NexCart
//
//  Created by shady ramadan on 30/06/2026.
//

import Foundation

enum BrandProductsEndPoint: EndPoint {
    case productsByVendor(brandName: String)

    var baseUrl: String {
        "https://mad46-ios-team9.myshopify.com/admin/api/2024-01"
    }

    var path: String {
        switch self {
        case .productsByVendor(let brandName):
            let vendor = brandName.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            let allowed = CharacterSet.urlQueryAllowed
            let encoded = vendor.addingPercentEncoding(withAllowedCharacters: allowed) ?? vendor
            return "/products.json?vendor=\(encoded)&limit=250"
        }
    }

    var method: String {
        "GET"
    }
}
