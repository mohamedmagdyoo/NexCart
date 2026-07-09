//
//  OutfitGenerationLoadingView.swift
//  NexCart
//
//  Created by Mohamed Magdy on 06/07/2026.
//

import SwiftUI

struct OutfitGenerationLoadingView: View {
    @State private var rotation: Double = 0
    @State private var pulse: Bool = false

    var body: some View {
        VStack(spacing: 24) {
            
            ZStack {
                Circle()
                    .stroke(
                        AngularGradient(colors: [.purple, .pink, .orange, .purple], center: .center),
                        lineWidth: 6
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(rotation))
                    .animation(.linear(duration: 1.4).repeatForever(autoreverses: false), value: rotation)

                Image(systemName: "sparkles")
                    .font(.system(size: 34))
                    .scaleEffect(pulse ? 1.15 : 0.9)
                    .animation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true), value: pulse)
            }

            Text("Styling your outfit…")
                .font(.headline)

            Text("This can take a few seconds while the AI works its magic.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            rotation = 360
            pulse = true
        }
    }
}
