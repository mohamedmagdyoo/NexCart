//
//  GoldBackButton.swift
//  NexCart
//
//  Created by shady ramadan on 02/07/2026.
//

import Foundation
import SwiftUI

struct GoldBackButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 15, weight: .semibold))
                Text("Back")
                    .font(AppColor.sans(16, .medium))
            }
            .foregroundColor(AppColor.gold)
        }
    }
}

extension View {
    func goldBackButton() -> some View {
        self
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    GoldBackButton()
                }
            }
    }
}
