//
//  UseCases.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import Foundation

struct AddAddressUseCase {
    private let repository: AddressRepository
 
    init(repository: AddressRepository) {
        self.repository = repository
    }
 
    func execute(_ address: AddressEntity) async throws {
        try await repository.addAddress(address)
    }
}
 
struct DeleteAddressUseCase {
    private let repository: AddressRepository
 
    init(repository: AddressRepository) {
        self.repository = repository
    }
 
    func execute(id: String) async throws {
        try await repository.deleteAddress(id: id)
    }
}
 

struct DeleteAllAddressesUseCase {
    private let repository: AddressRepository
 
    init(repository: AddressRepository) {
        self.repository = repository
    }
 
    func execute() async throws {
        try await repository.deleteAllAddresses()
    }
}
 

struct GetAllAddressesUseCase {
    private let repository: AddressRepository
 
    init(repository: AddressRepository) {
        self.repository = repository
    }
 
    func execute() async throws -> [AddressEntity] {
        try await repository.getAllAddresses()
    }
}
    
struct GetDefaultAddressUseCase {
    private let repository: AddressRepository

    init(repository: AddressRepository) {
        self.repository = repository
    }

    func execute() async throws -> AddressEntity? {
        try await repository.getDefaultAddress()
    }
}
