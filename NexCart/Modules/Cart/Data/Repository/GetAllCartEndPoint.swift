//
//  GetAllCartEndPoint.swift
//  NexCart
//
//  Created by Antoneos Philip on 01/07/2026.
//

import Foundation
import Foundation

struct CartResponseDto: Codable {
    let draftOrders: [CartOrderDto]

    enum CodingKeys: String, CodingKey {
        case draftOrders = "draft_orders"
    }
}

struct CartOrderDto: Codable, Identifiable {
    let id: Int
    let note: String?
    let taxesIncluded: Bool
    let currency: String
    let invoiceSentAt: String?
    let createdAt: String
    let updatedAt: String
    let taxExempt: Bool
    let completedAt: String?
    let name: String
    let allowDiscountCodesInCheckout: Bool
    let isB2B: Bool
    let status: String
    let lineItems: [DraftOrderLineItem]
    let apiClientId: Int
    let shippingAddress: DraftOrderAddress?
    let billingAddress: DraftOrderAddress?
    let invoiceUrl: String
    let createdOnApiVersionHandle: String
    let appliedDiscount: AppliedDiscount?
    let orderId: Int?
    let shippingLine: ShippingLine?
    let taxLines: [TaxLine]
    let tags: String
    let noteAttributes: [NoteAttribute]
    let totalPrice: String
    let subtotalPrice: String
    let totalTax: String
    let paymentTerms: PaymentTerms?
    let adminGraphqlApiId: String
    let customer: Customer?

    enum CodingKeys: String, CodingKey {
        case id
        case note
        case taxesIncluded = "taxes_included"
        case currency
        case invoiceSentAt = "invoice_sent_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxExempt = "tax_exempt"
        case completedAt = "completed_at"
        case name
        case allowDiscountCodesInCheckout = "allow_discount_codes_in_checkout?"
        case isB2B = "b2b?"
        case status
        case lineItems = "line_items"
        case apiClientId = "api_client_id"
        case shippingAddress = "shipping_address"
        case billingAddress = "billing_address"
        case invoiceUrl = "invoice_url"
        case createdOnApiVersionHandle = "created_on_api_version_handle"
        case appliedDiscount = "applied_discount"
        case orderId = "order_id"
        case shippingLine = "shipping_line"
        case taxLines = "tax_lines"
        case tags
        case noteAttributes = "note_attributes"
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case totalTax = "total_tax"
        case paymentTerms = "payment_terms"
        case adminGraphqlApiId = "admin_graphql_api_id"
        case customer
    }
}

struct DraftOrderLineItem: Codable, Identifiable {
    let id: Int
    let variantId: Int?
    let productId: Int?
    let title: String
    let variantTitle: String?
    let sku: String?
    let vendor: String?
    let quantity: Int
    let requiresShipping: Bool
    let taxable: Bool
    let giftCard: Bool
    let fulfillmentService: String
    let grams: Int
    let taxLines: [TaxLine]
    let appliedDiscount: AppliedDiscount?
    let name: String
    let properties: [LineItemProperty]
    let custom: Bool
    let price: String
    let adminGraphqlApiId: String

    enum CodingKeys: String, CodingKey {
        case id
        case variantId = "variant_id"
        case productId = "product_id"
        case title
        case variantTitle = "variant_title"
        case sku
        case vendor
        case quantity
        case requiresShipping = "requires_shipping"
        case taxable
        case giftCard = "gift_card"
        case fulfillmentService = "fulfillment_service"
        case grams
        case taxLines = "tax_lines"
        case appliedDiscount = "applied_discount"
        case name
        case properties
        case custom
        case price
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}

struct LineItemProperty: Codable {
    let name: String
    let value: String
}

struct DraftOrderAddress: Codable {
    let province: String?
    let country: String?
    let countryCode: String?
    let provinceCode: String?

    enum CodingKeys: String, CodingKey {
        case province
        case country
        case countryCode = "country_code"
        case provinceCode = "province_code"
    }
}

struct AppliedDiscount: Codable {
    let description: String?
    let value: String
    let title: String?
    let amount: String
    let valueType: String

    enum CodingKeys: String, CodingKey {
        case description
        case value
        case title
        case amount
        case valueType = "value_type"
    }
}

struct ShippingLine: Codable {
    let custom: Bool
    let handle: String
    let title: String
    let price: String
}

struct TaxLine: Codable {
    let title: String?
    let price: String?
    let rate: Double?
}

struct NoteAttribute: Codable {
    let name: String
    let value: String
}

struct PaymentTerms: Codable {
    let paymentTermsName: String?
    let paymentTermsType: String?

    enum CodingKeys: String, CodingKey {
        case paymentTermsName = "payment_terms_name"
        case paymentTermsType = "payment_terms_type"
    }
}

struct Customer: Codable, Identifiable {
    let id: Int
    let createdAt: String
    let updatedAt: String
    let ordersCount: Int
    let state: String
    let totalSpent: String
    let lastOrderId: Int?
    let note: String?
    let verifiedEmail: Bool
    let multipassIdentifier: String?
    let taxExempt: Bool
    let tags: String
    let lastOrderName: String?
    let currency: String
    let taxExemptions: [String]
    let emailMarketingConsent: MarketingConsent?
    let smsMarketingConsent: SmsMarketingConsent?
    let adminGraphqlApiId: String
    let defaultAddress: CustomerDefaultAddress?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case ordersCount = "orders_count"
        case state
        case totalSpent = "total_spent"
        case lastOrderId = "last_order_id"
        case note
        case verifiedEmail = "verified_email"
        case multipassIdentifier = "multipass_identifier"
        case taxExempt = "tax_exempt"
        case tags
        case lastOrderName = "last_order_name"
        case currency
        case taxExemptions = "tax_exemptions"
        case emailMarketingConsent = "email_marketing_consent"
        case smsMarketingConsent = "sms_marketing_consent"
        case adminGraphqlApiId = "admin_graphql_api_id"
        case defaultAddress = "default_address"
    }
}

struct MarketingConsent: Codable {
    let state: String
    let optInLevel: String?
    let consentUpdatedAt: String?

    enum CodingKeys: String, CodingKey {
        case state
        case optInLevel = "opt_in_level"
        case consentUpdatedAt = "consent_updated_at"
    }
}

struct SmsMarketingConsent: Codable {
    let state: String
    let optInLevel: String?
    let consentUpdatedAt: String?
    let consentCollectedFrom: String?

    enum CodingKeys: String, CodingKey {
        case state
        case optInLevel = "opt_in_level"
        case consentUpdatedAt = "consent_updated_at"
        case consentCollectedFrom = "consent_collected_from"
    }
}

struct CustomerDefaultAddress: Codable, Identifiable {
    let id: Int
    let customerId: Int
    let company: String?
    let province: String?
    let country: String?
    let provinceCode: String?
    let countryCode: String?
    let countryName: String?
    let isDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case customerId = "customer_id"
        case company
        case province
        case country
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        case isDefault = "default"
    }
}

