//
//  AddressError.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import Foundation


enum AddressError: Error, Equatable {


    case addressNotFound(id: String)

    case invalidAddress(field: String)
    case noDefaultAddressSet
    case localStorageFailed(underlying: String)
    case remoteStorageFailed(underlying: String)
    case syncFailed(underlying: String)
    case userNotAuthenticated
    case noInternetConnection
    case unknown(underlying: String)
}

extension AddressError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .addressNotFound(let id):
            return "No address was found with id \"\(id)\"."
        case .invalidAddress(let field):
            return "The address is missing or has an invalid value for \"\(field)\"."
        case .noDefaultAddressSet:
            return "No default address has been set yet."
        case .localStorageFailed(let underlying):
            return "Something went wrong saving your address locally. (\(underlying))"
        case .remoteStorageFailed(let underlying):
            return "Something went wrong syncing your address with the server. (\(underlying))"
        case .syncFailed(let underlying):
            return "Your addresses couldn't be fully synced. (\(underlying))"
        case .userNotAuthenticated:
            return "You need to be signed in to manage addresses."
        case .noInternetConnection:
            return "No internet connection. Please check your network and try again."
        case .unknown(let underlying):
            return "Something went wrong. (\(underlying))"
        }
    }
}
