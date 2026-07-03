//
//  CouponGraphQLQuery.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import Foundation

enum CouponGraphQLQuery {
    static let getCouponByCode = """
    query getCouponByCode($code: String!) {
      codeDiscountNodeByCode(code: $code) {
        id
        codeDiscount {
          ... on DiscountCodeBasic {
            title
            status
            startsAt
            endsAt
            codes(first: 1) { nodes { code } }
            customerGets {
              value {
                ... on DiscountPercentage { percentage }
                ... on DiscountAmount { amount { amount currencyCode } }
              }
            }
          }
        }
      }
    }
    """
}
