import SwiftUI

class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("selectedCurrency") var selectedCurrency: String = "USD"
    @AppStorage("selectedCountry") var selectedCountry: String = "United States"
    
    let availableCurrencies = ["USD", "EGP", "EUR", "SAR"]
    let availableCountries = ["United States", "Egypt", "Germany", "Saudi Arabia"]
    
    private init() {}
}
