import SwiftUI

struct SettingsView: View {
    @ObservedObject var appSettings = AppSettings.shared
    
    var body: some View {
        VStack(spacing: 24) {
            
            VStack(alignment: .leading, spacing: 8) {
                Text("APPEARANCE")
                    .font(AppColor.sans(13, .semibold))
                    .foregroundColor(AppColor.textSec)
                    .padding(.horizontal, 20)
                
                HStack {
                    Toggle(isOn: $appSettings.isDarkMode) {
                        Text("Dark Mode")
                            .font(AppColor.sans(16, .medium))
                            .foregroundColor(AppColor.textPrim)
                    }
                    .tint(AppColor.gold)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(AppColor.card)
            }
            .padding(.top, 24)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("PREFERENCES")
                    .font(AppColor.sans(13, .semibold))
                    .foregroundColor(AppColor.textSec)
                    .padding(.horizontal, 20)
                
                HStack {
                    Text("Currency")
                        .font(AppColor.sans(16, .medium))
                        .foregroundColor(AppColor.textPrim)
                    
                    Spacer()
                    
                    Picker("Currency", selection: $appSettings.selectedCurrency) {
                        ForEach(appSettings.availableCurrencies, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                    .tint(AppColor.textSec)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(AppColor.card)
            }
            
            Spacer()
        }
        .background(AppColor.bg.ignoresSafeArea())
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}
