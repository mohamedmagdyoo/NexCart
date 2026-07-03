//
//  CouponRemoteDataSource.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import Foundation


protocol CouponRemoteDataSource {
    func fetchCoupon(code: String) async throws -> CouponEntity
}

final class ShopifyCouponGraphQLDataSource: CouponRemoteDataSource {
    private let graphQLService: GraphQLServiceProtocol

    init(graphQLService: GraphQLServiceProtocol) {
        self.graphQLService = graphQLService
    }

    func fetchCoupon(code: String) async throws -> CouponEntity {
        let response: GraphQLCouponResponseDTO = try await graphQLService.fetch(
            query: CouponGraphQLQuery.getCouponByCode,
            variables: ["code": code]
        )

        if let errors = response.errors, !errors.isEmpty {
            throw CouponError.network(NSError(domain: "ShopifyGraphQL", code: -1,
                userInfo: [NSLocalizedDescriptionKey: errors.first?.message ?? "Unknown GraphQL error"]))
        }
        guard let node = response.data?.codeDiscountNodeByCode else {
            throw CouponError.couponNotFound
        }
        return try map(node)
    }

    private func map(_ node: CodeDiscountNodeDTO) throws -> CouponEntity {
        let discount = node.codeDiscount
        let codeString = discount.codes?.nodes.first?.code ?? ""
        let isActive = discount.status == "ACTIVE"

        let type: CouponDiscountType
        let value: Double
        var currencyCode: String?

        if let percentage = discount.customerGets?.value.percentage {
            type = .percentage
            value = percentage * 100 // 0.2 -> 20
        } else if let amount = discount.customerGets?.value.amount {
            type = .fixedAmount
            value = Double(amount.amount) ?? 0
            currencyCode = amount.currencyCode
        } else {
            throw CouponError.unsupportedDiscountType
        }

        let formatter = ISO8601DateFormatter()
        return CouponEntity(
            code: codeString,
            isActive: isActive,
            discountType: type,
            value: value,
            currencyCode: currencyCode,
            startsAt: discount.startsAt.flatMap(formatter.date),
            endsAt: discount.endsAt.flatMap(formatter.date)
        )
    }
}
