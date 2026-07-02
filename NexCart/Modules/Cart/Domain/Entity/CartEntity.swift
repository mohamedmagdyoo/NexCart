import Foundation

struct BagEntity: Identifiable {
    let id: Int
    let itemCount: Int
    let items: [BagItemEntity]
    let subtotal: Double
    let shipping: Double
    let total: Double
    let currency: String
    let customer: CustomerEntity?
}

struct BagItemEntity: Identifiable {
    let id: Int
    let brand: String
    let title: String
    let size: String
    let price: Double
    var quantity: Int
}

struct CustomerEntity: Identifiable {
    let id: Int
    let tags: String
    let ordersCount: Int
    let isVerifiedEmail: Bool
    let country: String?
}

extension CartOrderDto {
    func toEntity() -> BagEntity {
        let items = lineItems.map { $0.toEntity() }

        return BagEntity(
            id: id,
            itemCount: items.reduce(0) { $0 + $1.quantity },
            items: items,
            subtotal: Double(subtotalPrice) ?? 0,
            shipping: Double(shippingLine?.price ?? "0") ?? 0,
            total: Double(totalPrice) ?? 0,
            currency: currency,
            customer: customer?.toEntity()
        )
    }
}

extension DraftOrderLineItem {
    func toEntity() -> BagItemEntity {
        BagItemEntity(
            id: id,
            brand: vendor ?? "",
            title: title,
            size: variantTitle ?? "One size",
            price: Double(price) ?? 0,
            quantity: quantity
        )
    }
}

extension Customer {
    func toEntity() -> CustomerEntity {
        CustomerEntity(
            id: id,
            tags: tags,
            ordersCount: ordersCount,
            isVerifiedEmail: verifiedEmail,
            country: defaultAddress?.country
        )
    }
}

extension CartResponseDto {
    func toEntities() -> [BagEntity] {
        draftOrders.map { $0.toEntity() }
    }
}
