//
//  CollectionsListView.swift
//  NexCart
//
//  Created by Shady Ramadan on 02/07/2026.
//

import Foundation
import SwiftUI

struct CollectionsListView: View {
    @StateObject var viewModel: CollectionsListViewModel

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
                } else if viewModel.collections.isEmpty {
                    emptyCollectionsPlaceholder
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.collections) { collection in
                            NavigationLink {
                                CollectionDestinationView(collection: collection)
                            } label: {
                                CollectionCardView(collection: collection)
                            }
                        }
                    }
                    .padding(20)
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .background(AppColor.bg.ignoresSafeArea())
            .navigationTitle("Shop")
            .task { await viewModel.loadCollections() }
            .refreshable { await viewModel.loadCollections() }
        }
    }

    private var emptyCollectionsPlaceholder: some View {
        VStack(spacing: 20) {
            Image(systemName: "square.grid.2x2")
                .font(.system(size: 40))
                .foregroundColor(AppColor.textSec)

            Text("No Collections Available")
                .font(AppColor.serif(20, .medium))
                .foregroundColor(AppColor.textPrim)

            Text("There are currently no collections to display. Please check back later.")
                .font(AppColor.sans(14))
                .foregroundColor(AppColor.textSec)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}

private struct CollectionDestinationView: View {
    let collection: CustomCollectionEntity

    var body: some View {
        if let viewModel = DIContainer.shared.container.resolve(
            CollectionProductsViewModel.self,
            argument: collection
        ) {
            CollectionProductsView(viewModel: viewModel)
        } else {
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 32))
                    .foregroundColor(AppColor.textSec)
                Text("Couldn't open this collection. Please try again.")
                    .font(AppColor.sans(14))
                    .foregroundColor(AppColor.textSec)
            }
            .padding(.top, 80)
            .onAppear {
                #if DEBUG
                print("DI resolution failed for CollectionProductsViewModel with collection: \(collection.title)")
                #endif
            }
        }
    }
}

struct CollectionCardView: View {
    let collection: CustomCollectionEntity

    private var isAllCard: Bool { collection.id == "all" }

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                if isAllCard {
                    allCardBackground
                } else {
                    AppColor.surface

                    AsyncImage(url: URL(string: collection.imageURL)) { phase in
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
                            imageFallback
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(collection.title)
                .font(AppColor.sans(15, .medium))
                .foregroundColor(AppColor.textPrim)
                .lineLimit(1)
        }
    }

    
    private var allCardBackground: some View {
        ZStack {
            LinearGradient(
                colors: [AppColor.gold, AppColor.gold.opacity(0.55)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(Color.white.opacity(0.12))
                .frame(width: 110, height: 110)
                .offset(x: 45, y: -40)

            Image(systemName: "square.grid.2x2.fill")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(.white)
        }
    }

    // Softer, on-brand fallback for a broken/missing product image
    // (used for real collections, not the "All" tile).
    private var imageFallback: some View {
        ZStack {
            LinearGradient(
                colors: [AppColor.surface, AppColor.border.opacity(0.5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Image(systemName: "photo")
                .font(.system(size: 22))
                .foregroundColor(AppColor.textSec)
        }
    }
}
