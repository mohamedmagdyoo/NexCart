//
//  QuantitySelector.swift
//  NexCart
//
//  Created by Antoneos Philip on 29/06/2026.
//

import Foundation

import SwiftUI

struct QuantitySelector: View {
    @Binding var quantity: Int
    var minQuantity: Int = 1
    var maxQuantity: Int?

    var body: some View {
        HStack(spacing: 0) {
            stepButton(systemName: "minus", isEnabled: quantity > minQuantity) {
                guard quantity > minQuantity else { return }
                quantity -= 1
            }

            Text("\(quantity)")
                .font(AppColor.sans(15, .semibold))
                .foregroundColor(AppColor.textPrim)
                .frame(minWidth: 44)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.15), value: quantity)

            stepButton(systemName: "plus", isEnabled: canIncrement) {
                guard canIncrement else { return }
                quantity += 1
            }
        }
        .background(AppColor.pill)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColor.border, lineWidth: 1)
        )
    }

    private var canIncrement: Bool {
        guard let maxQuantity else { return true }
        return quantity < maxQuantity
    }

    private func stepButton(systemName: String, isEnabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(isEnabled ? AppColor.gold : AppColor.textSec.opacity(0.4))
                .frame(width: 40, height: 40)
        }
        .disabled(!isEnabled)
    }
}


