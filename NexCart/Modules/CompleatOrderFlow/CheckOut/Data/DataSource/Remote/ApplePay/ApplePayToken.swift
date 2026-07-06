//
//  ApplePayToken.swift
//  NexCart
//
//  Created by Mohamed Magdy on 04/07/2026.
//

import Foundation

struct ApplePayToken {
    let paymentData: Data
    let transactionIdentifier: String
    let network: String?
}
