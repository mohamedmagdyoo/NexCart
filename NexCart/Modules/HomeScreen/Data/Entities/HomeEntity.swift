import Foundation

struct ProductEntity: Identifiable, Hashable {
    let id: Int
    let brand: String
    let name: String
    let price: Double
    let originalPrice: Double?
    let imageURL: String
    let tag: ProductTag?
    var isFavorited: Bool = false
}

enum ProductTag: Hashable {
    case new
    case soldOut
}

struct BrandEntity: Identifiable, Hashable {
    let id: String
    let name: String
    let imageURL: String
    var isSelected: Bool = false
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
        let productTag: ProductTag? = if tagLower.contains("new") { .new }
                                      else if tagLower.contains("sold") { .soldOut }
                                      else { nil }

        return ProductEntity(
            id: id,
            brand: vendor,
            name: title,
            price: price,
            originalPrice: compareAt,
            imageURL: imageURL,
            tag: productTag
        )
    }
}
