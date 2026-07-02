//
//  AuthDTOs.swift
//  NexCart
//
//  Created by Mohamed Magdy on 01/07/2026.
//

import Foundation

struct ShopifyCustomerResponse: Codable {
    let customer: ShopifyCustomerDTO
}

struct ShopifyCustomerDTO: Codable {
    let id: Int
    let email: String?
    let firstName: String?
    let lastName: String?
    let phone: String?
    let createdAt: String?
    let updatedAt: String?
    let state: String?
    let verifiedEmail: Bool?
    let tags: String?
    let currency: String?
    let taxExempt: Bool?
    let addresses: [ShopifyAddressDTO]?
    let defaultAddress: ShopifyAddressDTO?
    let smsMarketingConsent: SmsMarketingConsent?
    let emailMarketingConsent: EmailMarketingConsent?

    enum CodingKeys: String, CodingKey {
        case id, email, phone, state, tags, currency
        case firstName = "first_name"
        case lastName = "last_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case verifiedEmail = "verified_email"
        case taxExempt = "tax_exempt"
        case addresses
        case defaultAddress = "default_address"
        case smsMarketingConsent = "sms_marketing_consent"
        case emailMarketingConsent = "email_marketing_consent"
    }
}

struct ShopifyAddressDTO: Codable {
    let id: Int?
    let customerId: Int?
    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let country: String?
    let zip: String?
    let phone: String?
    let isDefault: Bool?

    enum CodingKeys: String, CodingKey {
        case id, address1, address2, city, province, country, zip, phone
        case customerId = "customer_id"
        case isDefault = "default"
    }
}

struct SmsMarketingConsent: Codable {
    let state: String?
    let optInLevel: String?
    let consentUpdatedAt: String?

    enum CodingKeys: String, CodingKey {
        case state
        case optInLevel = "opt_in_level"
        case consentUpdatedAt = "consent_updated_at"
    }
}

struct EmailMarketingConsent: Codable {
    let state: String?
    let optInLevel: String?
    let consentUpdatedAt: String?

    enum CodingKeys: String, CodingKey {
        case state
        case optInLevel = "opt_in_level"
        case consentUpdatedAt = "consent_updated_at"
    }
}

struct ShopifyCreateCustomerRequest: Codable {
    struct Customer: Codable {
        let firstName: String
        let lastName: String
        let email: String
        let phone: String?
        let password: String
        let passwordConfirmation: String
        let sendEmailWelcome: Bool

        enum CodingKeys: String, CodingKey {
            case email, phone, password
            case firstName = "first_name"
            case lastName = "last_name"
            case passwordConfirmation = "password_confirmation"
            case sendEmailWelcome = "send_email_welcome"
        }
    }
    let customer: Customer
}
