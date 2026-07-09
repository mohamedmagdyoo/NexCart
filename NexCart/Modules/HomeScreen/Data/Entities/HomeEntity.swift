import Foundation


//MARK: TODO remove this folder to the domain layer
struct ProductEntity: Identifiable, Hashable {
    let id: Int
    let brand: String
    let name: String
    let price: Double
    let originalPrice: Double?
    let imageURL: String
    let tag: ProductTag?
    var isFavorited: Bool = false

    let bodyHtml: String?
    let vendor: String
    let productType: String
    let createdAt: String
    let handle: String
    let updatedAt: String
    let publishedAt: String?
    let publishedScope: String
    let tags: String?
    let status: String

    let variants: [VariantEntity]
    let options: [ProductOptionEntity]
    let images: [ProductImageEntity]
    let image: ProductImageEntity?
}
struct VariantEntity: Hashable {
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
}
struct ProductOptionEntity: Hashable {
    let id: Int
    let productId: Int
    let name: String
    let position: Int
    let values: [String]
}
struct ProductImageEntity: Hashable {
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
}

enum ProductTag: Hashable {
    case new
    case soldOut
}


struct HeroSlideEntity: Identifiable, Hashable {
    let id: String
    let collectionLabel: String
    let title: String
    let subtitle: String
    let imageURL: String
}

extension ProductDTO {
    func toEntity() -> ProductEntity {
        let price = Double(variants.first?.price ?? "0") ?? 0
        let compareAt = variants.first?.compareAtPrice.flatMap { Double($0) }
        let imageURL = images.first?.src ?? ""

        let tagLower = (tags ?? "").lowercased()

        var productTag: ProductTag? = nil
        if tagLower.contains("new") {
            productTag = .new
        } else if tagLower.contains("sold") {
            productTag = .soldOut
        }

        return ProductEntity(
            id: id,
            brand: vendor,
            name: title,
            price: Double(variants.first?.price ?? "0") ?? 0,
            originalPrice: variants.first?.compareAtPrice.flatMap(Double.init),
            imageURL: images.first?.src ?? "",
            tag: {
                let tagLower = (tags ?? "").lowercased()
                if tagLower.contains("new") { return .new }
                if tagLower.contains("sold") { return .soldOut }
                return nil
            }(),
            isFavorited: false,

            bodyHtml: bodyHtml,
            vendor: vendor,
            productType: productType,
            createdAt: createdAt,
            handle: handle,
            updatedAt: updatedAt,
            publishedAt: publishedAt,
            publishedScope: publishedScope,
            tags: tags,
            status: status,
            variants: variants.map { $0.toEntity() },
            options: options.map { $0.toEntity() },
            images: images.map { $0.toEntity() },
            image: image?.toEntity()
        )
    }
}
extension Variant {
    func toEntity() -> VariantEntity {
        VariantEntity(
            id: id,
            productId: productId,
            title: title,
            price: price,
            position: position,
            inventoryPolicy: inventoryPolicy,
            compareAtPrice: compareAtPrice,
            option1: option1,
            option2: option2,
            option3: option3,
            createdAt: createdAt,
            updatedAt: updatedAt,
            taxable: taxable,
            barcode: barcode,
            fulfillmentService: fulfillmentService,
            grams: grams,
            inventoryManagement: inventoryManagement,
            requiresShipping: requiresShipping,
            sku: sku,
            weight: weight,
            weightUnit: weightUnit,
            inventoryItemId: inventoryItemId,
            inventoryQuantity: inventoryQuantity,
            oldInventoryQuantity: oldInventoryQuantity,
            imageId: imageId
        )
    }
}

extension ProductOption {
    func toEntity() -> ProductOptionEntity {
        ProductOptionEntity(
            id: id,
            productId: productId,
            name: name,
            position: position,
            values: values
        )
    }
}
extension ProductImage {
    func toEntity() -> ProductImageEntity {
        ProductImageEntity(
            id: id,
            alt: alt,
            position: position,
            productId: productId,
            createdAt: createdAt,
            updatedAt: updatedAt,
            width: width,
            height: height,
            src: src,
            variantIds: variantIds
        )
    }
}
