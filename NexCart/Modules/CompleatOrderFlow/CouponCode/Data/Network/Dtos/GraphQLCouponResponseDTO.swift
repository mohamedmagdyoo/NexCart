//
//  GraphQLCouponResponseDTO.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import Foundation


struct GraphQLCouponResponseDTO: Decodable {
    let data: DataDTO?
    let errors: [GraphQLErrorDTO]?

    struct DataDTO: Decodable {
        let codeDiscountNodeByCode: CodeDiscountNodeDTO?
    }
    struct GraphQLErrorDTO: Decodable { let message: String }
}

struct CodeDiscountNodeDTO: Decodable {
    let id: String
    let codeDiscount: CodeDiscountDTO
}

struct CodeDiscountDTO: Decodable {
    let title: String?
    let status: String?
    let startsAt: String?
    let endsAt: String?
    let codes: CodesConnectionDTO?
    let customerGets: CustomerGetsDTO?
}

struct CodesConnectionDTO: Decodable { let nodes: [DiscountCodeNodeDTO] }
struct DiscountCodeNodeDTO: Decodable { let code: String }
struct CustomerGetsDTO: Decodable { let value: DiscountValueDTO }
struct DiscountValueDTO: Decodable {
    let percentage: Double?   // 0.2 = 20% — GraphQL returns a fraction, not a whole number
    let amount: MoneyDTO?
}
struct MoneyDTO: Decodable { let amount: String; let currencyCode: String }
