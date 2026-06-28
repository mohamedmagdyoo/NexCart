//
//  Components.swift
//  NexCart
//
//  Created by Antoneos Philip on 27/06/2026.
//

import Foundation
import SwiftUI

struct NavButton: View {
    let systemName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(AppColor.textPrim)
                .frame(width: 36, height: 36)
                .background(AppColor.white)
                .clipShape(Circle())
                .shadow(color: AppColor.border, radius: 4)
        }
    }
}

struct SizePill: View {
    let size: String
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            Text(size)
                .font(AppColor.sans(15, .semibold))
                .foregroundColor(AppColor.textPrim)
                .frame(width: 56, height: 48)
                .background(isSelected ? AppColor.gold : AppColor.pill)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct ColorSwatch: View {
    let color: String
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            Circle()
                .fill(swatchColor(for: color))
                .frame(width: 32, height: 32)
                .overlay(
                    Circle()
                        .stroke(isSelected ? AppColor.gold : AppColor.border, lineWidth: isSelected ? 2 : 1)
                )
                .padding(4)
                .overlay(
                    Circle()
                        .stroke(isSelected ? AppColor.gold : Color.clear, lineWidth: 1)
                        .frame(width: 44, height: 44)
                )
        }
    }

    private func swatchColor(for name: String) -> Color {
        switch name.lowercased() {
        case "black": return .black
        case "white": return .white
        case "gold": return AppColor.gold
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "navy": return Color(red: 0.0, green: 0.0, blue: 0.5)
        case "beige": return Color(red: 0.96, green: 0.91, blue: 0.81)
        case "gray", "grey": return .gray
        case "brown": return .brown
        case "pink": return .pink
        default: return AppColor.pill
        }
    }
}

struct InfoRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundColor(AppColor.gold)
            Text(text)
                .font(AppColor.sans(14))
                .foregroundColor(AppColor.textPrim)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

struct AddToBagButton: View {
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "bag")
                    .font(.system(size: 16, weight: .semibold))
                Text("Add to Bag")
                    .font(AppColor.sans(17, .semibold))
            }
            .foregroundColor(AppColor.textPrim)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(AppColor.gold)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
