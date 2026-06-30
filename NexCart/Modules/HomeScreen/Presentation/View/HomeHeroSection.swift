//
//  HomeHeroSection.swift
//  NexCart
//
//  Created by shady ramadan on 28/06/2026.

import SwiftUI

struct HomeHeroSection: View {
    let slides:    [HeroSlideEntity]
    @Binding var heroIndex: Int

    var body: some View {
        ZStack(alignment: .bottom) {
            carousel
            bottomGradient
            if slides.indices.contains(heroIndex) {
                heroOverlay(slide: slides[heroIndex])
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.65)
        .ignoresSafeArea(edges: .top)
    }

    private var carousel: some View {
        TabView(selection: $heroIndex) {
            ForEach(Array(slides.enumerated()), id: \.offset) { i, slide in
                heroCard(slide: slide).tag(i)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: UIScreen.main.bounds.height * 0.65)
        .ignoresSafeArea(edges: .top)
    }

    private func heroCard(slide: HeroSlideEntity) -> some View {
        ZStack(alignment: .topLeading) {
            // Product image
            AsyncImage(url: URL(string: slide.imageURL)) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                case .empty:
                    Color(hex: "#EDE8DF")
                        .overlay(ProgressView().tint(AppColor.gold))
                case .failure:
                    LinearGradient(
                        colors: [Color(hex: "#EDE8DF"), Color(hex: "#F5F0E8")],
                        startPoint: .top, endPoint: .bottom
                    )
                @unknown default:
                    Color(hex: "#EDE8DF")
                }
            }
            .ignoresSafeArea(edges: .top)

            LinearGradient(
                colors: [Color.black.opacity(0.35), .clear],
                startPoint: .top, endPoint: .init(x: 0.5, y: 0.4)
            )
            .ignoresSafeArea(edges: .top)

  
            HStack {
                Text("NexCart")
                    .font(AppColor.sans(18, .bold))
                    .tracking(4)
                    .foregroundColor(.white)

                Spacer()

                HStack(spacing: 20) {
                    Button(action: {}) {
                        Image(systemName: "bell")
                            .font(.system(size: 18, weight: .light))
                            .foregroundColor(.white)
                    }
                    Button(action: {}) {
                        Image(systemName: "bag")
                            .font(.system(size: 18, weight: .light))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var bottomGradient: some View {
        LinearGradient(
            colors: [.clear, AppColor.bg],
            startPoint: .init(x: 0.5, y: 0.3),
            endPoint: .bottom
        )
        .frame(height: 280)
        .allowsHitTesting(false)
    }

    private func heroOverlay(slide: HeroSlideEntity) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 6) {
                Circle().fill(AppColor.gold).frame(width: 6, height: 6)
                Text(slide.collectionLabel)
                    .font(AppColor.sans(10, .medium))
                    .tracking(3)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(Capsule().fill(Color.white.opacity(0.18)))
            .padding(.bottom, 14)

            Text(slide.title)
                .font(AppColor.serif(44))
                .foregroundColor(.white)
                .lineSpacing(2)
                .padding(.bottom, 10)

            Text(slide.subtitle)
                .font(AppColor.sans(13, .light))
                .foregroundColor(Color.white.opacity(0.75))
                .padding(.bottom, 20)

            HStack(spacing: 6) {
                ForEach(0..<slides.count, id: \.self) { i in
                    Capsule()
                        .fill(i == heroIndex ? AppColor.gold : AppColor.gold.opacity(0.35))
                        .frame(width: i == heroIndex ? 20 : 5, height: 3)
                        .animation(.easeInOut(duration: 0.2), value: heroIndex)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.bottom, 32)
    }
}
