//
//  AddressEntity.swift
//  NexCart
//
//  Created by Mohamed Magdy on 03/07/2026.
//

import Foundation


struct AddressEntity: Identifiable, Equatable {
    let id: String
    var fullName: String
    var streetAddress: String
    var city: String
    var state: String
    var zip: String

    var label: String?
    var isDefault: Bool

    /// Firestore document owner.
    var ownerUserId: String

    /// Last modification timestamp, used to support sync/conflict resolution.
    var updatedAt: Date

    init(
        id: String = UUID().uuidString,
        fullName: String,
        streetAddress: String,
        city: String,
        state: String,
        zip: String,
        label: String? = nil,
        isDefault: Bool = false,
        ownerUserId: String,
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.fullName = fullName
        self.streetAddress = streetAddress
        self.city = city
        self.state = state
        self.zip = zip
        self.label = label
        self.isDefault = isDefault
        self.ownerUserId = ownerUserId
        self.updatedAt = updatedAt
    }
}

extension AddressEntity {

    var cityStateZipLine: String {
        "\(city), \(state) \(zip)"
    }

    var displayName: String {
        guard let label, !label.isEmpty else { return fullName }
        return "\(fullName) — \(label)"
    }
}
