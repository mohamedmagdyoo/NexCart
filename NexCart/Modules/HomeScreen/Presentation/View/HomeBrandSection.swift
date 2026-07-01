//
//  HomeBrandSection.swift
//  NexCart
//
//  Created by shady ramadan on 28/06/2026.
//

import SwiftUI

struct HomeBrandsSection: View {

    let brands: [BrandEntity]
    let onBrandSelected: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            brandsAvatarRow
        }
        .padding(.bottom, 12)
    }

    private var header: some View {
        HStack {
            Text("SHOP BY BRAND")
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
        .padding(.bottom, 16)
    }

    private var brandsAvatarRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(brands.indices, id: \.self) { i in
                    brandAvatarItem(at: i)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 4)
        }
    }

    private func brandAvatarItem(at index: Int) -> some View {
        let brand = brands[index]
        let isSelected = brand.isSelected

        return NavigationLink {
            BrandProductsView(
                viewModel: DIContainer.shared.container.resolve(
                    BrandProductsViewModel.self,
                    argument: brand
                )!
            )
        } label: {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? AppColor.gold : Color.clear, lineWidth: 2)
                        .frame(width: 74, height: 74)
                    
                    if brand.imageURL.isEmpty {
                        fallbackBrandImage(name: brand.name)
                    } else {
                        AsyncImage(url: URL(string: brand.imageURL)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 66, height: 66)
                                    .clipShape(Circle())
                                    .contentShape(Circle())
                            case .empty:
                                Circle()
                                    .fill(AppColor.border.opacity(0.4))
                                    .frame(width: 66, height: 66)
                                    .overlay(ProgressView().tint(AppColor.gold))
                            case .failure:
                                fallbackBrandImage(name: brand.name)
                            @unknown default:
                                fallbackBrandImage(name: brand.name)
                            }
                        }
                    }
                }
                .shadow(color: Color.black.opacity(isSelected ? 0.08 : 0.02), radius: 4, x: 0, y: 2)
                
                Text(brand.name)
                    .font(AppColor.sans(11, isSelected ? .bold : .medium))
                    .tracking(0.5)
                    .foregroundColor(isSelected ? AppColor.gold : AppColor.textPrim)
                    .lineLimit(1)
                    .frame(width: 76)
            }
        }
        .simultaneousGesture(TapGesture().onEnded {
            onBrandSelected(index)
        })
        .buttonStyle(PlainButtonStyle())
    }
    
    private func fallbackBrandImage(name: String) -> some View {
        Circle()
            .fill(AppColor.border.opacity(0.4))
            .frame(width: 66, height: 66)
            .overlay(
                Text(name.prefix(1).uppercased())
                    .font(AppColor.sans(16, .bold))
                    .foregroundColor(AppColor.textSec)
            )
    }
}
