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
        NavigationStack {
            ScrollView {
                if viewModel.isLoading {
                    ProgressView().padding(.top, 60)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .font(AppColor.sans(14))
                        .foregroundColor(AppColor.textSec)
                        .padding(.top, 60)
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
            .task { await viewModel.loadBrands() }
            .refreshable { await viewModel.loadBrands() }
        }
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
            .onAppear {
                #if DEBUG
                print("DI resolution failed for BrandProductsViewModel with brand: \(brand.name)")
                #endif
            }
        }
    }
}

struct BrandCardView: View {
    let brand: BrandEntity

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                AppColor.surface

                AsyncImage(url: URL(string: brand.imageURL)) { phase in
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
                        ProgressView()
                    case .failure:
                        Image(systemName: "photo").foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
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
}
