//
//  ProfileView.swift
//  NexCart
//
//  Created by Antoneos Philip on 05/07/2026.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Circle()
                        .fill(AppColor.surface)
                        .frame(width: 60, height: 60)
                        .overlay(
                            Text(String(viewModel.user?.displayName?.first ?? "S"))
                                .font(AppColor.sans(24, .semibold))
                                .foregroundColor(AppColor.textPrim)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.user?.displayName ?? "user")
                            .font(AppColor.sans(18, .bold))
                            .foregroundColor(AppColor.textPrim)
                        
                        Text(viewModel.user?.email ?? "user@example.com")
                            .font(AppColor.sans(14, .regular))
                            .foregroundColor(AppColor.textSec)
                    }
                    .padding(.leading, 12)
                    
                    Spacer()
                    
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .font(.system(size: 24))
                            .foregroundColor(AppColor.textPrim)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
                
                VStack(spacing: 0) {
                    NavigationLink(destination: SettingsView()) {
                        ProfileRowContent(icon: "gearshape", title: "Settings")
                    }
                    ProfileRowContent(icon: "doc.plaintext", title: "Orders")
                    ProfileRowContent(icon: "map", title: "Addresses")
                }
                
                Spacer()
            }
            .background(AppColor.bg.ignoresSafeArea())
            .onAppear {
                viewModel.fetchProfile()
            }
        }
    }
}

struct ProfileRowContent: View {
    let icon: String
    let title: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(AppColor.textPrim)
                .frame(width: 28, alignment: .leading)
            
            Text(title)
                .font(AppColor.sans(16, .medium))
                .foregroundColor(AppColor.textPrim)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(AppColor.textSec)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(AppColor.card)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(AppColor.border)
                .padding(.leading, 64),
            alignment: .bottom
        )
    }
}

#Preview {
    ProfileView()
}
