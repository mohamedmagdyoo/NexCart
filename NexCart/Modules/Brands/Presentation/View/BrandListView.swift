//
//  BrandListView.swift
//  NexCart
//
//  Created by shady ramadan on 30/06/2026.
//
import Foundation
import SwiftUI

struct BrandsListView: View {
    @StateObject var viewModel: BrandsListViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                ProgressView().padding(.top, 60)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .font(AppColor.sans(14))
                    .foregroundColor(AppColor.textSec)
                    .padding(.top, 60)
            } else if viewModel.brands.isEmpty {
                emptyBrandsPlaceholder
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.brands) { brand in
                        NavigationLink {
                            BrandDestinationView(brand: brand)
                        } label: {
                            BrandCardView(brand: brand)
                        }
                    }
                }
                .padding(20)
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(AppColor.bg.ignoresSafeArea())
        .navigationTitle("Brands")
        .navigationBarBackButtonHidden(true)
        .goldBackButton()
        .task { await viewModel.loadBrands() }
        .refreshable { await viewModel.loadBrands() }
    }

    private var emptyBrandsPlaceholder: some View {
        VStack(spacing: 20) {
            Image(systemName: "tag.slash")
                .font(.system(size: 40))
                .foregroundColor(AppColor.textSec)
            
            Text("No Brands Available")
                .font(AppColor.serif(20, .medium))
                .foregroundColor(AppColor.textPrim)
            
            Text("There are currently no brands to display. Please check back later.")
                .font(AppColor.sans(14))
                .foregroundColor(AppColor.textSec)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}

private struct BrandDestinationView: View {
    let brand: BrandEntity

    var body: some View {
        if let viewModel = DIContainer.shared.container.resolve(
            BrandProductsViewModel.self,
            argument: brand
        ) {
            BrandProductsView(viewModel: viewModel)
        } else {
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 32))
                    .foregroundColor(AppColor.textSec)
                Text("Couldn't open this brand. Please try again.")
                    .font(AppColor.sans(14))
                    .foregroundColor(AppColor.textSec)
            }
            .padding(.top, 80)
        }
    }
}

struct BrandCardView: View {
    let brand: BrandEntity

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                AppColor.surface

                if let url = URL(string: brand.imageURL), !brand.imageURL.isEmpty {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            Color.clear
                                .overlay(
                                    image
                                        .resizable()
                                        .scaledToFill()
                                )
                                .clipped()
                        case .empty:
                            ProgressView().tint(AppColor.gold)
                        case .failure:
                            coolPlaceholder
                        @unknown default:
                            coolPlaceholder
                        }
                    }
                } else {
                    coolPlaceholder
                }
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(brand.name)
                .font(AppColor.sans(15, .medium))
                .foregroundColor(AppColor.textPrim)
                .lineLimit(1)
        }
    }
    
    private var coolPlaceholder: some View {
        ZStack {
            LinearGradient(
                colors: [AppColor.surface, AppColor.border.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            VStack(spacing: 10) {
                Image(systemName: "bag.circle")
                    .font(.system(size: 36, weight: .light))
                    .foregroundColor(AppColor.gold.opacity(0.8))
                
                Text(String(brand.name.prefix(1)).uppercased())
                    .font(AppColor.serif(20, .bold))
                    .foregroundColor(AppColor.textSec)
            }
        }
    }
}
