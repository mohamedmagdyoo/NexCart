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
 
    private var currentUserId: String {
        AppConstants.shared.getUserEntity()?.id ?? ""
    }
 
    var body: some View {
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
                            Text(viewModel.user?.displayName ?? appSettings.loc("User Name", "اسم المستخدم"))
                                .font(.headline)
 
                            Text(viewModel.user?.email ?? "user@example.com")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
 
                Section(header: Text(appSettings.loc("Account", "الحساب"))) {
                    NavigationLink(destination: OrdersView(viewModel: DIContainer.shared.container.resolve(OrdersViewModel.self)!)) {
                        SettingsRowView(icon: "clock.fill", iconColor: .blue, title: appSettings.loc("Order History", "سجل الطلبات"))
                    }
                    NavigationLink(destination: Text(appSettings.loc("Wishlist", "قائمة الأمنيات"))) {
                        SettingsRowView(icon: "heart.fill", iconColor: .red, title: appSettings.loc("Wishlist", "قائمة الأمنيات"))
                    }
                    NavigationLink(destination: AddressListView(
                        viewModel: DIContainer.shared.container.resolve(AddressViewModel.self)!,
                        ownerUserId: currentUserId
                    )) {
                        SettingsRowView(icon: "mappin.circle.fill", iconColor: .green, title: appSettings.loc("Saved Addresses", "العناوين المحفوظة"))
                    }
                }
 
                Section(header: Text(appSettings.loc("Preferences", "التفضيلات"))) {
                    Toggle(isOn: $appSettings.isDarkMode) {
                        SettingsRowView(icon: "moon.fill", iconColor: .indigo, title: appSettings.loc("Dark Mode", "الوضع الداكن"))
                    }
                    .tint(.indigo)
 
                    Picker(selection: $appSettings.selectedLanguage, label: SettingsRowView(icon: "character.book.closed.fill", iconColor: .blue, title: appSettings.loc("Language", "اللغة"))) {
                        Text("English").tag("en")
                        Text("العربية").tag("ar")
                    }
 
                    Picker(selection: $appSettings.selectedCurrency, label: SettingsRowView(icon: "dollarsign.circle.fill", iconColor: .orange, title: appSettings.loc("Currency", "العملة"))) {
                        ForEach(appSettings.availableCurrencies, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
 
                    Picker(selection: $appSettings.selectedCountry, label: SettingsRowView(icon: "globe", iconColor: .purple, title: appSettings.loc("Country", "البلد"))) {
                        ForEach(appSettings.availableCountries, id: \.self) { country in
                            Text(country).tag(country)
                        }
                    }
                }
 
                Section {
                    Button(action: {
                        viewModel.logout()
                    }) {
                        HStack {
                            Spacer()
                            Text(appSettings.loc("Logout", "تسجيل الخروج"))
                                .foregroundColor(.red)
                                .font(.body.weight(.semibold))
                            Spacer()
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle(appSettings.loc("Profile", "الملف الشخصي"))
            .onAppear {
                viewModel.fetchProfile()
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
