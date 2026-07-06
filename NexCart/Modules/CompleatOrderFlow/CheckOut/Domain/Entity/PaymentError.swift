//
//  PaymentError.swift
//  NexCart
//
//  Created by Mohamed Magdy on 04/07/2026.
//

import Foundation

enum PaymentError: Error {
    case cancelled
    case notAvailable
    case presentationFailed
    case unknown(Error)
}
