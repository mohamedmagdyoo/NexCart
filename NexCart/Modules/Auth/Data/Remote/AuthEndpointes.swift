//
//  AuthEndpointes.swift
//  NexCart
//
//  Created by Mohamed Magdy on 01/07/2026.
//

import Foundation


enum AuthEndpointes: EndPoint {
    case creatNewAccount(signUpCredentials: SignUpCredentials)
    case getShopifyCustomerByEmail(email: String)

    var baseUrl: String {
        return "https://mad46-ios-team9.myshopify.com/admin/api/2024-01/"
    }

    var path: String {
        switch self {
        case .creatNewAccount:
            return "customers.json"
        case .getShopifyCustomerByEmail(let email):
            let allowed = CharacterSet.urlQueryAllowed
            let encodedQuery = "email:\(email)".addingPercentEncoding(withAllowedCharacters: allowed) ?? email
            return "customers/search.json?query=\(encodedQuery)"
        }
    }

    var method: String {
        switch self {
        case .creatNewAccount:
            return "POST"
        case .getShopifyCustomerByEmail:
            return "GET"
        }
    }

    var body: Data? {
        switch self {
        case .creatNewAccount(let credentials):
            let request = ShopifyCreateCustomerRequest(
                customer: .init(
                    firstName: credentials.firstName,
                    lastName: credentials.lastName,
                    email: credentials.email,
                    phone: credentials.phone,
                    password: credentials.password,
                    passwordConfirmation: credentials.passwordConfirmation,
                    sendEmailWelcome: credentials.sendEmailWelcome
                )
            )
            return try? JSONEncoder().encode(request)
        case .getShopifyCustomerByEmail:
            return nil
        }
    }
}
