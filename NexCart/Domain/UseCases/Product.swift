//
//  Product.swift
//  NexCart
//
//  Created by Antoneos Philip on 28/06/2026.
//

import Foundation
struct Product: Decodable {
    let id: Int
    let title: String
    let bodyHtml: String?
    let vendor: String
    let productType: String
    let createdAt: String
    let handle: String
    let updatedAt: String
    let publishedAt: String?
    let publishedScope: String
    let tags: String
    let status: String
    let variants: [Variant]
    let options: [ProductOption]
    let images: [ProductImage]
    let image: ProductImage?

    enum CodingKeys: String, CodingKey {
        case id, title, vendor, handle, tags, status, variants, options, images, image
        case bodyHtml        = "body_html"
        case productType     = "product_type"
        case createdAt       = "created_at"
        case updatedAt       = "updated_at"
        case publishedAt     = "published_at"
        case publishedScope  = "published_scope"
    }
}

struct Variant: Decodable {
    let id: Int
    let productId: Int
    let title: String
    let price: String
    let position: Int
    let inventoryPolicy: String
    let compareAtPrice: String?
    let option1: String?
    let option2: String?
    let option3: String?
    let createdAt: String
    let updatedAt: String
    let taxable: Bool
    let barcode: String?
    let fulfillmentService: String
    let grams: Int
    let inventoryManagement: String?
    let requiresShipping: Bool
    let sku: String?
    let weight: Double
    let weightUnit: String
    let inventoryItemId: Int
    let inventoryQuantity: Int
    let oldInventoryQuantity: Int
    let imageId: Int?

    enum CodingKeys: String, CodingKey {
        case id, title, price, position, taxable, barcode, grams, weight, sku
        case productId           = "product_id"
        case inventoryPolicy     = "inventory_policy"
        case compareAtPrice      = "compare_at_price"
        case option1             = "option1"
        case option2             = "option2"
        case option3             = "option3"
        case createdAt           = "created_at"
        case updatedAt           = "updated_at"
        case fulfillmentService  = "fulfillment_service"
        case inventoryManagement = "inventory_management"
        case requiresShipping    = "requires_shipping"
        case weightUnit          = "weight_unit"
        case inventoryItemId     = "inventory_item_id"
        case inventoryQuantity   = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case imageId             = "image_id"
    }
}

struct ProductOption: Decodable {
    let id: Int
    let productId: Int
    let name: String
    let position: Int
    let values: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, position, values
        case productId = "product_id"
    }
}

struct ProductImage: Decodable {
    let id: Int
    let alt: String?
    let position: Int
    let productId: Int
    let createdAt: String
    let updatedAt: String
    let width: Int
    let height: Int
    let src: String
    let variantIds: [Int]
    
    enum CodingKeys: String, CodingKey {
        case id, alt, position, width, height, src
        case productId  = "product_id"
        case createdAt  = "created_at"
        case updatedAt  = "updated_at"
        case variantIds = "variant_ids"
    }
}
