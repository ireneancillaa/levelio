//
//  View+Extensions.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 22/09/26.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// Transparent Circular Liquid Glass Button Style
struct LevelioGlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .frame(width: 36, height: 36)
            .background(.ultraThinMaterial, in: Circle())
            .overlay(
                Circle()
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .opacity(configuration.isPressed ? 0.75 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == LevelioGlassButtonStyle {
    static var glassCircle: LevelioGlassButtonStyle {
        LevelioGlassButtonStyle()
    }
}


