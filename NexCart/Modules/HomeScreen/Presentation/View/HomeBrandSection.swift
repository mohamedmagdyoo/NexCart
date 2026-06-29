//
//  HomeBrandSection.swift
//  NexCart
//
//  Created by shady ramadan on 28/06/2026.
//


import SwiftUI

struct HomeBrandsSection: View {

    let brands:  [BrandEntity]
    let onBrandSelected: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            pillsRow
        }
        .padding(.bottom, 4)
    }

    private var header: some View {
        HStack {
            Text("BRANDS")
                .font(AppColor.sans(11, .semibold))
                .tracking(3)
                .foregroundColor(AppColor.textSec)
            Spacer()
            Button("See all") {}
                .font(AppColor.sans(13))
                .foregroundColor(AppColor.gold)
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 14)
    }

    private var pillsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(brands.indices, id: \.self) { i in
                    brandPill(at: i)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 4)
        }
    }

    private func brandPill(at index: Int) -> some View {
        let brand      = brands[index]
        let isSelected = brand.isSelected

        return Button { onBrandSelected(index) } label: {
            Text(brand.name)
                .font(AppColor.sans(11, .semibold))
                .tracking(1.5)
                .foregroundColor(isSelected ? AppColor.white : AppColor.textPrim)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    Capsule().fill(isSelected ? AppColor.pillSel : AppColor.pill)
                )
                .overlay(
                    Capsule().stroke(AppColor.border, lineWidth: isSelected ? 0 : 0.5)
                )
        }
    }
}
