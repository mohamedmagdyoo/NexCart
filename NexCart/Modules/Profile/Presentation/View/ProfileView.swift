//
//  ProfileView.swift
//  NexCart
//
//  Created by Antoneos Philip on 05/07/2026.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @ObservedObject var appSettings = AppSettings.shared
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text(String(viewModel.user?.displayName?.first ?? "S"))
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.primary)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.user?.displayName ?? "User Name")
                                .font(.headline)
                            
                            Text(viewModel.user?.email ?? "user@example.com")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section(header: Text("Account")) {
                    NavigationLink(destination: OrdersView(viewModel: DIContainer.shared.container.resolve(OrdersViewModel.self)!)) {
                        SettingsRowView(icon: "clock.fill", iconColor: .blue, title: "Order History")
                    }
                    NavigationLink(destination: Text("Wishlist")) {
                        SettingsRowView(icon: "heart.fill", iconColor: .red, title: "Wishlist")
                    }
                    NavigationLink(destination: AddressListView(viewModel: DIContainer.shared.container.resolve(AddressViewModel.self)!)) {
                        SettingsRowView(icon: "mappin.circle.fill", iconColor: .green, title: "Saved Addresses")
                    }
                    NavigationLink {
                        OutfitGeneratorView(
                            viewModel: DIContainer.shared.container.resolve(OutfitGeneratorViewModel.self)!
                        )
                    } label: {
                        SettingsRowView(icon: "wand.and.stars", iconColor: .purple, title: "My Studio")
                    }
                }
                
                Section(header: Text("Preferences")) {
                    Toggle(isOn: $appSettings.isDarkMode) {
                        SettingsRowView(icon: "moon.fill", iconColor: .indigo, title: "Dark Mode")
                    }
                    .tint(.indigo)
                    
                    Picker(selection: $appSettings.selectedCurrency, label: SettingsRowView(icon: "dollarsign.circle.fill", iconColor: .orange, title: "Currency")) {
                        ForEach(appSettings.availableCurrencies, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                    
                    Picker(selection: $appSettings.selectedCountry, label: SettingsRowView(icon: "globe", iconColor: .purple, title: "Country")) {
                        ForEach(appSettings.availableCountries, id: \.self) { country in
                            Text(country).tag(country)
                        }
                    }
                }
                
//                Section(header: Text("Security")) {
//                    NavigationLink(destination: Text("Change Password")) {
//                        SettingsRowView(icon: "lock.fill", iconColor: .gray, title: "Change Password")
//                    }
//                    NavigationLink(destination: Text("Verify Email")) {
//                        SettingsRowView(icon: "checkmark.shield.fill", iconColor: .blue, title: "Verify Email")
//                    }
//                }
                
                Section {
                    Button(action: {
                        viewModel.logout()
                    }) {
                        HStack {
                            Spacer()
                            Text("Logout")
                                .foregroundColor(.red)
                                .font(.body.weight(.semibold))
                            Spacer()
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Profile")
            .onAppear {
                viewModel.fetchProfile()
            }
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let iconColor: Color
    let title: String
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(iconColor)
                .frame(width: 30, height: 30)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .medium))
                )
            Text(title)
                .foregroundColor(.primary)
        }
    }
}


#Preview {
    ProfileView()
}

