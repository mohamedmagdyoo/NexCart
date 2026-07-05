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
    
    @EnvironmentObject var tabBarManager: TabBarManager

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

            NavigationLink {
                BrandsListView(
                    viewModel: DIContainer.shared.container.resolve(BrandsListViewModel.self)!
                )
                .onAppear { tabBarManager.isHidden = true }
            } label: {
                Text("See all")
                    .font(AppColor.sans(13))
                    .foregroundColor(AppColor.gold)
            }
            .simultaneousGesture(TapGesture().onEnded {
                tabBarManager.isHidden = true
            })
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 16)
    }

    private var brandsAvatarRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(Array(brands.enumerated()), id: \.element.id) { index, brand in
                    if brand.name.lowercased() != "all" {
                        Button {
                            onBrandSelected(index)
                            tabBarManager.isHidden = true
                        } label: {
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(AppColor.surface)
                                        .frame(width: 66, height: 66)
                                    
                                    if let url = URL(string: brand.imageURL), !brand.imageURL.isEmpty {
                                        AsyncImage(url: url) { phase in
                                            switch phase {
                                            case .success(let image):
                                                image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 66, height: 66)
                                                    .clipShape(Circle())
                                            case .empty:
                                                Circle()
                                                    .strokeBorder(AppColor.border.opacity(0.4))
                                                    .frame(width: 66, height: 66)
                                                    .overlay(ProgressView().tint(AppColor.gold))
                                            case .failure:
                                                fallbackBrandImage(name: brand.name)
                                            @unknown default:
                                                fallbackBrandImage(name: brand.name)
                                            }
                                        }
                                    } else {
                                        fallbackBrandImage(name: brand.name)
                                    }
                                }
                                .shadow(color: Color.black.opacity(0.02), radius: 4, x: 0, y: 2)
                                
                                Text(brand.name)
                                    .font(AppColor.sans(11, .medium))
                                    .tracking(0.5)
                                    .foregroundColor(AppColor.textPrim)
                                    .lineLimit(1)
                                    .frame(width: 76)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    private func fallbackBrandImage(name: String) -> some View {
        Circle()
            .fill(AppColor.border.opacity(0.4))
            .frame(width: 66, height: 66)
            .overlay(
                Text(String(name.prefix(1)).uppercased())
                    .font(AppColor.sans(16, .bold))
                    .foregroundColor(AppColor.textSec)
            )
    }
}
