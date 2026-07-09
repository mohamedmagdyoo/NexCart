//
//  GuestAlert.swift
//  NexCart
//
//  Created by shady ramadan on 05/07/2026.
//

import SwiftUI

struct GuestAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var navigateToSignIn: Bool

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture { withAnimation(.spring(response: 0.3)) { isPresented = false } }

                VStack(spacing: 0) {
                    ZStack {
                        Circle()
                            .fill(AppColor.gold.opacity(0.12))
                            .frame(width: 64, height: 64)
                        Image(systemName: "lock.fill")
                            .font(.system(size: 26, weight: .medium))
                            .foregroundColor(AppColor.gold)
                    }
                    .padding(.top, 32)
                    .padding(.bottom, 16)

                    Text("Sign in required")
                        .font(AppColor.serif(20, .medium))
                        .foregroundColor(AppColor.textPrim)
                        .padding(.bottom, 8)

                    Text("Create an account to access\nall features.")
                        .font(AppColor.sans(14))
                        .foregroundColor(AppColor.textSec)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 28)

                    Divider().background(AppColor.border)

                    HStack(spacing: 0) {
                        Button {
                            withAnimation(.spring(response: 0.3)) { isPresented = false }
                        } label: {
                            Text("Cancel")
                                .font(AppColor.sans(15, .medium))
                                .foregroundColor(AppColor.textSec)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                        }

                        Divider()
                            .frame(width: 0.5, height: 52)
                            .background(AppColor.border)

                        Button {
                            withAnimation(.spring(response: 0.3)) { isPresented = false }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                navigateToSignIn = true
                            }
                        } label: {
                            Text("Sign in")
                                .font(AppColor.sans(15, .semibold))
                                .foregroundColor(AppColor.gold)
                                .frame(maxWidth: .infinity)
                                .frame(height: 52)
                        }
                    }
                }
                .background(AppColor.card)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color.black.opacity(0.12), radius: 24, x: 0, y: 8)
                .padding(.horizontal, 40)
                .transition(.scale(scale: 0.92).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isPresented)
        .fullScreenCover(isPresented: $navigateToSignIn) {
            SignInScreen()
        }
    }
}

extension View {
    func guestAlert(isPresented: Binding<Bool>, navigateToSignIn: Binding<Bool>) -> some View {
        modifier(GuestAlertModifier(isPresented: isPresented, navigateToSignIn: navigateToSignIn))
    }
}
