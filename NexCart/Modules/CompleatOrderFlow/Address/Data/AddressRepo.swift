//
//  AddressRepo.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import Foundation




final class AddressRepositoryImpl: AddressRepository {
    
    private let localDataSource: AddressDao
    
    init(
        localDataSource: AddressDao
    ) {
        self.localDataSource = localDataSource
        
    }
    
    func addAddress(_ address: AddressEntity) async throws {
        var addressToSave = address
        try localDataSource.insert(addressToSave)
    }
    
    func deleteAddress(id: String) async throws {
        
        try localDataSource.delete(id: id)
    }
    
    func deleteAllAddresses() async throws {
        
        try localDataSource.deleteAll()
    }
    
    func getAllAddresses(ownerID: String) async throws -> [AddressEntity] {
        try localDataSource.fetchAll(ownerID: ownerID)
    }
    
    func getDefaultAddress(ownerID: String) async throws -> AddressEntity? {
        try localDataSource.fetchDefault(ownerID: ownerID)
    }
    
}
