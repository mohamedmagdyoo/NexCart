//
//  GuestCard.swift
//  NexCart
//
//  Created by shady ramadan on 05/07/2026.
//

import SwiftUI
 
struct GuestGuard<Content: View>: View {
    let content: Content
    @State private var navigateToSignIn = false
     private var isGuest: Bool {
        guard let data = UserDefaults.standard.data(forKey: "userEntity"),
              let user = try? JSONDecoder().decode(UserEntity.self, from: data)
        else { return true }
        return user.isGuest
    }
 
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
 
    var body: some View {
        Group {
            if isGuest {
                guestPlaceholder
            } else {
                content
            }
        }
        .fullScreenCover(isPresented: $navigateToSignIn) {
            SignInScreen()
        }
    }
 
    private var guestPlaceholder: some View {
        VStack(spacing: 20) {
            Spacer()
 
            Image(systemName: "lock.circle")
                .font(.system(size: 52, weight: .light))
                .foregroundColor(AppColor.textSec.opacity(0.4))
 
            Text("Sign in to continue")
                .font(AppColor.serif(24, .medium))
                .foregroundColor(AppColor.textPrim)
 
            Text("Create an account to save favorites,\ntrack orders, and manage your cart.")
                .font(AppColor.sans(15))
                .foregroundColor(AppColor.textSec)
                .multilineTextAlignment(.center)
 
            Button {
                navigateToSignIn = true
            } label: {
                Text("Sign in")
                    .font(AppColor.sans(16, .semibold))
                    .foregroundColor(AppColor.btnText) // ✅ متغير حسب المود
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColor.btnBg)      // ✅ متغير حسب المود
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 40)
            .padding(.top, 8)
 
            Spacer()
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.bg.ignoresSafeArea())
    }
}
