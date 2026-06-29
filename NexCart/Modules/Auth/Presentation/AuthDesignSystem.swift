//
//  AuthDesignSystem.swift
//  NexCart
//
//  Created by Mohamed Magdy on 28/06/2026.
//

import SwiftUI

// MARK: - Colors
extension Color {
    static let authBackground   = Color(hex: "#F5EFE9")  // warm beige background
    static let authTitle        = Color(hex: "#1A1A1A")  // near black
    static let authSubtitle     = Color(hex: "#7A7A7A")  // gray subtitle
    static let authLabel        = Color(hex: "#1A1A1A")  // field label
    static let authFieldBorder  = Color(hex: "#DADADA")  // light gray border
    static let authFieldText    = Color(hex: "#1A1A1A")  // field input text
    static let authPlaceholder  = Color(hex: "#BABABA")  // placeholder text
    static let authForgotPass   = Color(hex: "#C0622A")  // terracotta/orange
    static let authPrimaryBtn   = Color(hex: "#1A1A1A")  // black primary button
    static let authPrimaryBtnTx = Color(hex: "#FFFFFF")  // white button text
    static let authSocialBorder = Color(hex: "#DADADA")  // social button border
    static let authSocialText   = Color(hex: "#1A1A1A")  // social button text
    static let authFooterText   = Color(hex: "#7A7A7A")  // "New here?"
    static let authFooterLink   = Color(hex: "#1A1A1A")  // "Create an account"
}


// MARK: - ObsidianField
struct ObsidianField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    @State private var isPasswordVisible: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            // Label
            Text(label)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.authLabel)
                .tracking(1.2)

            // Field
            ZStack(alignment: .trailing) {
                Group {
                    if isSecure && !isPasswordVisible {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .foregroundColor(.authFieldText)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .padding(.trailing, isSecure ? 44 : 0)

                // Eye toggle for password
                if isSecure {
                    Button {
                        isPasswordVisible.toggle()
                    } label: {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.authPlaceholder)
                            .padding(.trailing, 16)
                    }
                }
            }
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.authFieldBorder, lineWidth: 1)
            )
        }
    }
}

// MARK: - Primary Button Style (black pill)
struct AuthPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.authPrimaryBtnTx)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                Color.authPrimaryBtn
                    .opacity(configuration.isPressed ? 0.8 : 1.0)
            )
            .cornerRadius(50)
    }
}

// MARK: - Social Button Style (white outlined pill)
struct AuthSocialButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(.authSocialText)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.white.opacity(configuration.isPressed ? 0.7 : 1.0))
            .cornerRadius(50)
            .overlay(
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.authSocialBorder, lineWidth: 1)
            )
    }
}

// MARK: - Divider with text
struct AuthDivider: View {
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.authFieldBorder)
            Text(text)
                .font(.caption)
                .foregroundColor(.authSubtitle)
                .fixedSize()
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.authFieldBorder)
        }
    }
}

// MARK: - Auth Footer Link
struct AuthFooterLink: View {
    let message: String
    let linkText: String
    let action: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text(message)
                .font(.footnote)
                .foregroundColor(.authFooterText)
            Button(action: action) {
                Text(linkText)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.authFooterLink)
            }
        }
    }
}
