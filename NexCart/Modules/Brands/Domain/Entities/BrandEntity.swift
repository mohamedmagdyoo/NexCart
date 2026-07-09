//
//  BrandEntity.swift
//  NexCart
//
//  Created by shady ramadan on 30/06/2026.
//

import Foundation

struct BrandEntity : Identifiable, Hashable {
    let id: String
    let name: String
    let imageURL: String
    var isSelected: Bool = false
}
