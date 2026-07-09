//
//  AddressRepoInterface.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//



import Foundation

protocol AddressRepository {


    func addAddress(_ address: AddressEntity) async throws

    func deleteAddress(id: String) async throws

    func deleteAllAddresses() async throws

    func getAllAddresses(ownerID: String) async throws -> [AddressEntity]

    func getDefaultAddress(ownerID: String) async throws -> AddressEntity?
}
