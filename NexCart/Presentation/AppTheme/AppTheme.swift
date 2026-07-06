//
//  AppTheme.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation
import SwiftUI

enum AppColor {
    static var bg: Color { AppSettings.shared.isDarkMode ? Color(hex: "#121212") : Color(hex: "#FAFAF8") }
    static var surface: Color { AppSettings.shared.isDarkMode ? Color(hex: "#1E1E1E") : Color(hex: "#F2F0EB") }
    static var card: Color { AppSettings.shared.isDarkMode ? Color(hex: "#242424") : Color(hex: "#FFFFFF") }
    static var border: Color { AppSettings.shared.isDarkMode ? Color(white: 1, opacity: 0.08) : Color(white: 0, opacity: 0.08) }
    static let white = Color.white
    static let gold = Color(hex: "#B8924A")
    static var textPrim: Color { AppSettings.shared.isDarkMode ? Color(hex: "#E0E0E0") : Color(hex: "#1A1A1A") }
    static var textSec: Color { AppSettings.shared.isDarkMode ? Color(white: 1, opacity: 0.40) : Color(white: 0, opacity: 0.40) }
    static let tagNew = Color(hex: "#B8924A")
    static let tagSold = Color(hex: "#C0392B")
    static var pill: Color { AppSettings.shared.isDarkMode ? Color(white: 1, opacity: 0.06) : Color(white: 0, opacity: 0.06) }
    static var pillSel: Color { AppSettings.shared.isDarkMode ? Color(hex: "#E0E0E0") : Color(hex: "#1A1A1A") }

    static func serif(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        Font.custom("Georgia", size: size).weight(weight)
    }

    static func sans(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        Font.system(size: size, weight: weight)
    }
}

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var val: UInt64 = 0
        Scanner(string: h).scanHexInt64(&val)
        let r = Double((val >> 16) & 0xFF) / 255
        let g = Double((val >>  8) & 0xFF) / 255
        let b = Double( val        & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
