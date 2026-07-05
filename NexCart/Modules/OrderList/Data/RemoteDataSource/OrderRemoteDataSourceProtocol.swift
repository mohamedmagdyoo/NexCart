//
//  OrderRemoteDataSourceProtocol.swift
//  NexCart
//
//  Created by shady ramadan on 04/07/2026.
//

import Foundation

struct ShopifyProductResponseDTO: Codable {
    let product: ShopifyProductDTO
}
struct ShopifyProductDTO: Codable {
    let image: ShopifyProductImageDTO?
}
struct ShopifyProductImageDTO: Codable {
    let src: String
}

protocol OrderRemoteDataSourceProtocol {
    func fetchOrders(customerId: Int) async throws -> [OrderEntity]
}

final class OrderRemoteDataSource: OrderRemoteDataSourceProtocol {
    private let apiService: ApiServiceProtocol
    
    init(apiService: ApiServiceProtocol = ApiService()) {
        self.apiService = apiService
    }
    
    func fetchOrders(customerId: Int) async throws -> [OrderEntity] {
        let response: OrdersResponseDTO = try await apiService.fetch(
            endPoint: OrderEndPoint.customerOrders(customerId: customerId)
        )
        
        var orders = response.orders.map { $0.toEntity() }
                await withTaskGroup(of: (Int, String).self) { group in
            let productIds = Set(response.orders.flatMap { $0.lineItems }.compactMap { $0.productId })
            
            for productId in productIds {
                group.addTask {
                    do {
                        let prodResponse: ShopifyProductResponseDTO = try await self.apiService.fetch(
                            endPoint: OrderEndPoint.productDetails(productId: productId)
                        )
                        return (productId, prodResponse.product.image?.src ?? "")
                    } catch {
                        return (productId, "")
                    }
                }
            }
            
            var imageCache: [Int: String] = [:]
            for await (productId, imageUrl) in group {
                imageCache[productId] = imageUrl
            }
            
                    orders = response.orders.map { orderDto in
                let lineItems = orderDto.lineItems.map { itemDto in
                    let entity = itemDto.toEntity()
                    if let prodId = itemDto.productId, let cachedUrl = imageCache[prodId], !cachedUrl.isEmpty {
                        return OrderLineItemEntity(
                            id: entity.id,
                            title: entity.title,
                            price: entity.price,
                            quantity: entity.quantity,
                            imageURL: cachedUrl,
                            vendor: entity.vendor,
                            variantTitle: entity.variantTitle
                        )
                    }
                    return entity
                }
                
                let orderEntity = orderDto.toEntity()
                return OrderEntity(
                    id: orderEntity.id,
                    orderNumber: orderEntity.orderNumber,
                    name: orderEntity.name,
                    totalPrice: orderEntity.totalPrice,
                    financialStatus: orderEntity.financialStatus,
                    fulfillmentStatus: orderEntity.fulfillmentStatus,
                    createdAt: orderEntity.createdAt,
                    lineItems: lineItems
                )
            }
        }
        
        return orders
    }
}
