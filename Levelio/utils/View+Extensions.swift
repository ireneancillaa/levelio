//
//  View+Extensions.swift
//  Levelio
//
//  Created by Irene Ancilla Chow on 22/09/26.
//

import SwiftUI
import UIKit

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// Helper praktis di level View untuk mengecek layar compact (tinggi <= 700 pt)
    var isCompactScreen: Bool {
        UIScreen.isCompact
    }
}

extension UIWindowScene {
    /// Mengambil UIWindowScene aktif di foreground, atau scene pertama yang tersedia.
    static var current: UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
            ?? UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.first
    }
}

extension UIScreen {
    /// Mengambil tinggi layar saat ini melalui context UIWindowScene atau keyWindow aktif tanpa warning deprecation.
    static var currentHeight: CGFloat {
        if let window = UIWindowScene.current?.windows.first(where: { $0.isKeyWindow }) ?? UIWindowScene.current?.windows.first {
            return window.bounds.height
        }
        return UIWindowScene.current?.screen.bounds.height ?? 844
    }
    
    /// Static property: Mengecek apakah layar berukuran compact (tinggi <= 700 pt)
    static var isCompact: Bool {
        currentHeight <= 700
    }
    
    /// Instance property fallback jika dipanggil pada instance UIScreen
    var isCompact: Bool {
        bounds.height <= 700
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
