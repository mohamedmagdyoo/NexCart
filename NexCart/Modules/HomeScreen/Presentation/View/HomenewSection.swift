//
//  HomenewSection.swift
//  NexCart
//
//  Created by shady ramadan on 28/06/2026.


import SwiftUI

struct HomeNewInSection: View {

    let products: [ProductEntity]
    let isLoading: Bool
    let errorMessage: String?
    let onToggleFavorite: (Int) -> Void
    let onProductSelected: (ProductEntity) -> Void
    let onRetry: () async -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader
            if isLoading {
                HomeSkeletonGrid()
            } else if let error = errorMessage {
                HomeErrorView(message: error, onRetry: onRetry)
            } else {
                productGrid
            }
        }
    }

    private var sectionHeader: some View {
        HStack {
            Text("Availbale Now")
                .font(AppColor.serif(28))
                .foregroundColor(AppColor.textPrim)
            Spacer()
            Button("See all") {}
                .font(AppColor.sans(13))
                .foregroundColor(AppColor.gold)
        }
        .padding(.horizontal, 20)
        .padding(.top, 28)
        .padding(.bottom, 16)
    }

    private var productGrid: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
            spacing: 10
        ) {
            ForEach(products.indices, id: \.self) { i in
                HomeProductCard(product: products[i], onToggleFavorite: { onToggleFavorite(i) }, onTap: { onProductSelected(products[i]) })
            }
        }
        .padding(.horizontal, 16)
    }
}

struct HomeProductCard: View {

    let product: ProductEntity
    let onToggleFavorite: () -> Void
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            imageArea
            infoArea
        }
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
        .background(AppColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColor.border, lineWidth: 0.5))
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }

    private var imageArea: some View {
        ZStack(alignment: .top) {
            AsyncImage(url: URL(string: product.imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable().scaledToFill()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 180, maxHeight: 180)
                        .clipped()
                case .empty:
                    imagePlaceholder
                        .overlay(ProgressView().tint(AppColor.gold))
                case .failure:
                    imagePlaceholder
                @unknown default:
                    imagePlaceholder
                }
            }
            .frame(height: 180)
            .clipped()

            HStack(alignment: .top) {
                if let tag = product.tag { tagBadge(tag) } else { Spacer() }
                Spacer()
                heartButton
            }
            .padding(10)
        }
        .frame(height: 180)
    }

    private var heartButton: some View {
        Button(action: onToggleFavorite) {
            Image(systemName: product.isFavorited ? "heart.fill" : "heart")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(product.isFavorited ? AppColor.gold : AppColor.textSec)
                .frame(width: 30, height: 30)
                .background(Circle().fill(Color.white.opacity(0.88)))
        }
    }

    private func tagBadge(_ tag: ProductTag) -> some View {
        var label: String
        var bg: Color
        var fg: Color
        
        switch tag {
            case .new:
                label = "NEW"
                bg = AppColor.tagNew
                fg = .white
            case .soldOut:
                label = "SOLD OUT"
                bg = AppColor.tagSold
                fg = .white
        }
        
        return Text(label)
            .font(AppColor.sans(8, .bold))
            .tracking(1.5)
            .foregroundColor(fg)
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(Capsule().fill(bg))
    }

    private var imagePlaceholder: some View {
        LinearGradient(
            colors: [Color(hex: "#EDE8DF"), Color(hex: "#F5F0E8")],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }

    private var infoArea: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(product.brand.uppercased())
                .font(AppColor.sans(8, .semibold))
                .tracking(2)
                .foregroundColor(AppColor.gold)
                .padding(.top, 10)

            Text(product.name)
                .font(AppColor.serif(13))
                .foregroundColor(AppColor.textPrim)
                .lineLimit(2)

            HStack(spacing: 6) {
                Text("$\(Int(product.price))")
                    .font(AppColor.sans(13, .semibold))
                    .foregroundColor(AppColor.textPrim)
                if let orig = product.originalPrice {
                    Text("$\(Int(orig))")
                        .font(AppColor.sans(11))
                        .foregroundColor(AppColor.textSec)
                        .strikethrough(true, color: AppColor.textSec)
                }
            }
            .padding(.bottom, 10)
        }
        .padding(.horizontal, 10)
    }
}

struct HomeSkeletonGrid: View {
    var body: some View {
        LazyVGrid(
            columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)],
            spacing: 10
        ) {
            ForEach(0..<6, id: \.self) { _ in skeletonCard }
        }
        .padding(.horizontal, 16)
    }

    private var skeletonCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle().fill(AppColor.surface).frame(height: 180).shimmering()
            VStack(alignment: .leading, spacing: 7) {
                Rectangle().fill(AppColor.surface).frame(width: 70,  height: 8).shimmering()
                Rectangle().fill(AppColor.surface).frame(height: 11).shimmering()
                Rectangle().fill(AppColor.surface).frame(width: 50,  height: 11).shimmering()
            }
            .padding(10)
        }
        .background(AppColor.card)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppColor.border, lineWidth: 0.5))
    }
}

struct HomeErrorView: View {
    let message: String
    let onRetry: () async -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 40))
                .foregroundColor(AppColor.textSec)
            Text("Something went wrong")
                .font(AppColor.sans(16, .medium))
                .foregroundColor(AppColor.textPrim)
            Text(message)
                .font(AppColor.sans(12))
                .foregroundColor(AppColor.textSec)
                .multilineTextAlignment(.center)
            Button { Task { await onRetry() } } label: {
                Text("Try Again")
                    .font(AppColor.sans(13, .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 28).padding(.vertical, 12)
                    .background(AppColor.gold).clipShape(Capsule())
            }
        }
        .padding(32).frame(maxWidth: .infinity)
    }
}

struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .clear, location: phase - 0.3),
                        .init(color: .black.opacity(0.04), location: phase),
                        .init(color: .clear, location: phase + 0.3),
                    ]),
                    startPoint: .leading, endPoint: .trailing
                )
                .animation(.linear(duration: 1.4).repeatForever(autoreverses: false), value: phase)
            )
            .onAppear { phase = 1.5 }
            .clipped()
    }
}

extension View {
    func shimmering() -> some View { modifier(ShimmerModifier()) }
}
