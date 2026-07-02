//
//  Toast.swift
//  NexCart
//
//  Created by Antoneos Philip on 29/06/2026.
//

import Foundation
import SwiftUI

struct ToastView: View {
    let message: String
    var isError: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isError ? "exclamationmark.circle.fill" : "checkmark.circle.fill")
                .foregroundColor(isError ? AppColor.tagSold : AppColor.gold)

            Text(message)
                .font(AppColor.sans(14, .semibold))
                .foregroundColor(AppColor.textPrim)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(AppColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColor.border, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.3), radius: 12, y: 4)
    }
}


