//
//  AppTheme.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation
import SwiftUI

//
//  AppTheme.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation
import SwiftUI

enum AppColor {
        static var bg: Color { AppSettings.shared.isDarkMode ? Color(hex: "#0F0F0F") : Color(hex: "#FAFAF8") }
    static var surface: Color { AppSettings.shared.isDarkMode ? Color(hex: "#1A1A1A") : Color(hex: "#F2F0EB") }
    static var card: Color { AppSettings.shared.isDarkMode ? Color(hex: "#222222") : Color(hex: "#FFFFFF") }
    static var border: Color { AppSettings.shared.isDarkMode ? Color(white: 1, opacity: 0.12) : Color(white: 0, opacity: 0.08) }
    
       static var gold: Color { AppSettings.shared.isDarkMode ? Color(hex: "#D5B263") : Color(hex: "#B8924A") }
    static let white = Color.white
  
    static var textPrim: Color { AppSettings.shared.isDarkMode ? Color(hex: "#F5F5F7") : Color(hex: "#1A1A1A") }
    static var textSec: Color { AppSettings.shared.isDarkMode ? Color(white: 1, opacity: 0.55) : Color(white: 0, opacity: 0.45) }
    
  
    static var btnBg: Color { AppSettings.shared.isDarkMode ? Color(hex: "#F5F5F7") : Color(hex: "#1A1A1A") }
    static var btnText: Color { AppSettings.shared.isDarkMode ? Color(hex: "#1A1A1A") : Color(hex: "#FFFFFF") }

    static var tagNew: Color { gold }
    static let tagSold = Color(hex: "#C0392B")
    
    static var pill: Color { AppSettings.shared.isDarkMode ? Color(white: 1, opacity: 0.08) : Color(white: 0, opacity: 0.06) }
    static var pillSel: Color { AppSettings.shared.isDarkMode ? Color(hex: "#F5F5F7") : Color(hex: "#1A1A1A") }


    static func serif(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        Font.custom("Georgia", size: size).weight(weight)
    }

    static func sans(_ size: CGFloat, _ weight: Font.Weight = .regular) -> Font {
        Font.system(size: size).weight(weight)
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
