//
//  AppTheme.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import Foundation
import SwiftUI

enum AppColor {
    static let bg = Color(hex: "#0A0A0A")
    static let surface = Color(hex: "#161616")
    static let card = Color(hex: "#1C1C1C")
    static let border = Color(white: 1, opacity: 0.08)
    static let white = Color.white
    static let gold = Color(hex: "#C9A96E")
    static let textPrim = Color.white
    static let textSec = Color(white: 1, opacity: 0.55)
    static let tagNew = Color(hex: "#C9A96E")
    static let tagSold = Color(hex: "#C0392B")
    static let pill = Color(white: 1, opacity: 0.10)
    static let pillSel = Color(white: 1, opacity: 0.90)

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
