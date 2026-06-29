import SwiftUI

struct OnboardingPage {
    let imageName: String
    let eyebrow: String
    let headline: String
    let body: String
}

struct OnboardingFlowView: View {

    var onFinish: () -> Void

    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            imageName: "onboarding1",
            eyebrow: "WELCOME",
            headline: "Wear what feels like you.",
            body: "A pocket-sized boutique of considered pieces — soft fabrics, honest cuts, made to be lived in."
        ),
        OnboardingPage(
            imageName: "onboarding2",
            eyebrow: "CURATED",
            headline: "A small, thoughtful wardrobe.",
            body: "Every piece is hand-picked from independent makers who care about how things are made and how they last."
        ),
        OnboardingPage(
            imageName: "onboarding3",
            eyebrow: "DELIVERY",
            headline: "Arrives like a gift.",
            body: "Discreet packaging, signature service — delivered with the same care it was made with."
        )
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            AppColor.bg
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    if currentPage < pages.count - 1 {
                        Button(action: onFinish) {
                            Text("Skip")
                                .font(AppColor.sans(13))
                                .foregroundColor(AppColor.textSec)
                        }
                        .padding(.trailing, 20)
                    }
                }
                .frame(height: 80)
                .padding(.top, 2)

                TabView(selection: $currentPage) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        ImageCard(imageName: page.imageName)
                            .padding(.horizontal, 16)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: UIScreen.main.bounds.height * 0.56)
                .animation(.easeInOut(duration: 0.35), value: currentPage)

                VStack(spacing: 6) {
                    Text(pages[currentPage].eyebrow)
                        .font(AppColor.sans(10, .semibold))
                        .foregroundColor(AppColor.gold)
                        .tracking(3)
                        .padding(.top, 20)

                    Text(pages[currentPage].headline)
                        .font(AppColor.serif(26))
                        .foregroundColor(AppColor.textPrim)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.top, 2)

                    Text(pages[currentPage].body)
                        .font(AppColor.sans(13))
                        .foregroundColor(AppColor.textSec)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 32)
                        .padding(.top, 4)
                }
                .animation(.easeInOut(duration: 0.25), value: currentPage)
                .id(currentPage)

                HStack(spacing: 5) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(index == currentPage ? AppColor.pillSel : AppColor.pill)
                            .frame(
                                width: index == currentPage ? 18 : 6,
                                height: 6
                            )
                            .animation(.easeInOut(duration: 0.2), value: currentPage)
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 88)
                
                Button(action: advance) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "#3D1A0E"))

                        Text(currentPage == pages.count - 1 ? "GET STARTED" : "CONTINUE")
                            .font(AppColor.sans(12, .semibold))
                            .foregroundColor(AppColor.white)
                            .tracking(2.5)
                    }
                    .frame(height: 48)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, bottomSafeArea() + 12)
            }
        }
    
    }

    private func advance() {
        if currentPage < pages.count - 1 {
            withAnimation(.easeInOut(duration: 0.3)) { currentPage += 1 }
        } else {
            onFinish()
        }
    }

    private func bottomSafeArea() -> CGFloat {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.windows.first?.safeAreaInsets.bottom ?? 0
    }
}

private struct ImageCard: View {
    let imageName: String

    var body: some View {
        GeometryReader { geo in
            Group {
                if UIImage(named: imageName) != nil {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                } else {
                    AppColor.surface
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "photo")
                                    .font(.system(size: 28, weight: .light))
                                    .foregroundColor(AppColor.gold)
                                Text(imageName)
                                    .font(AppColor.sans(11))
                                    .foregroundColor(AppColor.textSec)
                            }
                        )
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(AppColor.border, lineWidth: 1)
            )
        }
    }
}
