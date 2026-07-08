import SwiftUI

class AppSettings: ObservableObject {
    static let shared = AppSettings()

    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("selectedCurrency") var selectedCurrency: String = "USD"
    @AppStorage("selectedCountry") var selectedCountry: String = "United States"
    @AppStorage("selectedLanguage") var selectedLanguage: String = "en"

    let availableCurrencies = ["USD", "EGP", "EUR", "SAR"]
    let availableCountries = ["United States", "Egypt", "Germany", "Saudi Arabia"]
    let availableLanguages = ["en", "ar"]

    var isArabic: Bool { selectedLanguage == "ar" }

    var currencyRate: Double {
        switch selectedCurrency {
        case "EGP": return 50.0
        case "EUR": return 0.92
        case "SAR": return 3.75
        default: return 1.0 // USD
        }
    }

    func loc(_ en: String, _ ar: String) -> String {
        isArabic ? ar : en
    }

    var layoutDirection: LayoutDirection {
        isArabic ? .rightToLeft : .leftToRight
    }

    private init() {}
}
