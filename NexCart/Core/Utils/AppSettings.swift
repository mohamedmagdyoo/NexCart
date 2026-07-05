import SwiftUI

class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("selectedCurrency") var selectedCurrency: String = "USD"
    
    let availableCurrencies = ["USD", "EGP", "EUR", "SAR"]
    
    private init() {}
}
