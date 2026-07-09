//
//  HomeHeroSection.swift
//  NexCart
//
//  Created by shady ramadan on 28/06/2026.

import SwiftUI

struct HomeHeroSection: View {
    private let heroCouponCode = "FASHION60"
    let slides:    [HeroSlideEntity]
    @Binding var heroIndex: Int
    @Binding var showCouponToast : Bool
    @AppStorage("pendingCouponCode") private var pendingCouponCode: String = ""
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
                   .padding(.bottom, 16)
    
               Button {
                   pendingCouponCode = heroCouponCode
                   withAnimation(.spring(response: 0.3)) { showCouponToast = true }
                   DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                       withAnimation(.easeOut) { showCouponToast = false }
                   }
               } label: {
                   HStack(spacing: 10) {
                       Image(systemName: "tag.fill")
                           .font(.system(size: 13))
                           .foregroundColor(AppColor.gold)
    
                       VStack(alignment: .leading, spacing: 1) {
                           Text("Use code for 60% off")
                               .font(AppColor.sans(11, .medium))
                               .foregroundColor(Color.white.opacity(0.85))
                           Text(heroCouponCode)
                               .font(AppColor.sans(15, .bold))
                               .tracking(2)
                               .foregroundColor(.white)
                       }
    
                       Spacer()
    
                       HStack(spacing: 4) {
                           Image(systemName: "arrow.right.circle")
                               .font(.system(size: 12))
                           Text("Apply")
                               .font(AppColor.sans(12, .medium))
                       }
                       .foregroundColor(AppColor.gold)
                       .padding(.horizontal, 12)
                       .padding(.vertical, 6)
                       .background(Capsule().fill(Color.white.opacity(0.15)))
                   }
                   .padding(.horizontal, 16)
                   .padding(.vertical, 12)
                   .background(
                       RoundedRectangle(cornerRadius: 14, style: .continuous)
                           .fill(Color.black.opacity(0.35))
                           .overlay(
                               RoundedRectangle(cornerRadius: 14, style: .continuous)
                                   .stroke(AppColor.gold.opacity(0.5), lineWidth: 1)
                           )
                   )
               }
               .buttonStyle(PlainButtonStyle())
               .padding(.bottom, 16)
    
              
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
           private var couponToast: some View {
           VStack {
               HStack(spacing: 10) {
                   Image(systemName: "checkmark.circle.fill")
                       .foregroundColor(AppColor.gold)
                       .font(.system(size: 16))
                   VStack(alignment: .leading, spacing: 2) {
                       Text("Code copied!")
                           .font(AppColor.sans(14, .semibold))
                           .foregroundColor(.white)
                       Text("Added to your cart automatically")
                           .font(AppColor.sans(12))
                           .foregroundColor(Color.white.opacity(0.75))
                   }
                   Spacer()
               }
               .padding(.horizontal, 18)
               .padding(.vertical, 14)
               .background(
                   RoundedRectangle(cornerRadius: 14, style: .continuous)
                       .fill(Color.black.opacity(0.85))
               )
               .padding(.horizontal, 20)
               .padding(.top, 56)
    
               Spacer()
           }
           .transition(.move(edge: .top).combined(with: .opacity))
       }
   }
    
    



