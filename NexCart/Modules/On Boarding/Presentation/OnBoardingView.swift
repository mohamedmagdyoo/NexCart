//
//  OnBoardingView.swift
//  NexCart
//
//  Created by Antoneos Philip on 29/06/2026.
//

import SwiftUI



struct OnboardingFlowView: View {
    var onFinish: () -> Void

    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            eyebrow: "EST. MMXVIII",
            title: "OBSIDIAN",
            subtitle: "MAISON DE MODE",
            body: "Curated luxury, delivered with intent.",
            symbol: "sparkles"
        ),
        OnboardingPage(
            eyebrow: "SELECTION",
            title: "CURATED",
            subtitle: "FOR THE FEW",
            body: "Every piece hand-picked by our style council, never mass produced.",
            symbol: "bag"
        ),
        OnboardingPage(
            eyebrow: "DELIVERY",
            title: "WHITE GLOVE",
            subtitle: "AT YOUR DOOR",
            body: "Discreet packaging, signature delivery, white glove service worldwide.",
            symbol: "shippingbox"
        )
    ]

    var body: some View {
        ZStack {
            AppColor.bg
                .ignoresSafeArea()

            RadialGradient(
                colors: [AppColor.gold.opacity(0.16), AppColor.bg.opacity(0)],
                center: .center,
                startRadius: 10,
                endRadius: 280
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button(action: onFinish) {
                            Text("Skip")
                                .font(AppColor.sans(14))
                                .foregroundColor(AppColor.textSec)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .frame(height: 36)

                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentPage)

                VStack(spacing: 28) {
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Capsule()
                                .fill(index == currentPage ? AppColor.gold : AppColor.pill)
                                .frame(width: index == currentPage ? 22 : 7, height: 7)
                                .animation(.easeInOut(duration: 0.25), value: currentPage)
                        }
                    }

                    Button(action: advance) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                            .font(AppColor.sans(16, .semibold))
                            .foregroundColor(AppColor.bg)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(AppColor.gold)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 28)
            }
        }
    }

    private func advance() {
        if currentPage < pages.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) {
                currentPage += 1
            }
        } else {
            onFinish()
        }
    }
}

private struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 18) {
            Spacer()

            Image(systemName: page.symbol)
                .font(.system(size: 34, weight: .light))
                .foregroundColor(AppColor.gold)
                .padding(.bottom, 8)

            ornamentLine(height: 32)

            Text(page.eyebrow)
                .font(AppColor.sans(11, .medium))
                .foregroundColor(AppColor.gold)
                .tracking(4)

            Text(page.title)
                .font(AppColor.serif(42))
                .foregroundColor(AppColor.textPrim)

            Text(page.subtitle)
                .font(AppColor.sans(12, .medium))
                .foregroundColor(AppColor.textSec)
                .tracking(5)

            ornamentLine(height: 18)

            Text(page.body)
                .font(AppColor.sans(15))
                .foregroundColor(AppColor.textSec)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 6)

            Spacer()
            Spacer()
        }
        .padding(.horizontal, 16)
    }

    private func ornamentLine(height: CGFloat) -> some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [AppColor.gold.opacity(0), AppColor.gold, AppColor.gold.opacity(0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 1, height: height)
    }
}

