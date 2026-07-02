//
//  AuthShopifyService.swift
//  NexCart
//
//  Created by Mohamed Magdy on 01/07/2026.
//

import Foundation

protocol AuthShopifyServiceProtocol{
    func signUp(signUpCredentials: SignUpCredentials) async throws -> ShopifyCustomerResponse
    func getShpifyCustomerByEmail(email: String) async throws -> ShopifyCustomerDTO
}

class AuthShopifyService: AuthShopifyServiceProtocol{
    private var service: ApiService = ApiService()
    
    func signUp(signUpCredentials: SignUpCredentials) async throws -> ShopifyCustomerResponse {
        let endPoint :AuthEndpointes = .creatNewAccount(signUpCredentials: signUpCredentials)
        return try await service.fetch(endPoint: endPoint)
    }
    
    func getShpifyCustomerByEmail(email: String) async throws -> ShopifyCustomerDTO {
        
        let response: ShopifyCustomerSearchResponse = try await service.fetch(
            endPoint: AuthEndpointes.getShopifyCustomerByEmail(email: email)
        )
        guard let shopifyCutomer = response.customers.first else{
            throw AuthError.userNotFound
        }
        
        return shopifyCutomer
    }
}
