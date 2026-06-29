//
//  ProductDto.swift
//  NexCart
//
//  Created by shady ramadan on 28/06/2026.
//


import Foundation

struct ProductsResponseDTO: Decodable {
    let products: [ProductDTO]
}

struct ProductDTO: Decodable {
    let id:       Int
    let title:    String
    let vendor:   String
    let bodyHtml: String?
    let images:   [ProductImageDTO]
    let variants: [ProductVariantDTO]
    let tags:     String?

    enum CodingKeys: String, CodingKey {
        case id, title, vendor, images, variants, tags
        case bodyHtml = "body_html"
    }
}

struct ProductImageDTO: Decodable {
    let src: String
}

struct ProductVariantDTO: Decodable {
    let price:          String
    let compareAtPrice: String?

    enum CodingKeys: String, CodingKey {
        case price
        case compareAtPrice = "compare_at_price"
    }
}

struct MetafieldsResponseDTO: Decodable {
    let metafields: [MetafieldDTO]
}

struct MetafieldDTO: Decodable {
    let namespace: String
    let key:       String
    let value:     String
}
