//
//  Glass.swift
//  Planto
//
//  Created by Fahdah Alsamari on 29/04/1447 AH.
//

import SwiftUI

struct GlassBackground: ViewModifier {
    var corner: CGFloat = 20
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: corner, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .stroke(.white.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.35), radius: 20, x: 0, y: 12)
    }
}

extension View {
    func glass(corner: CGFloat = 20) -> some View { modifier(GlassBackground(corner: corner)) }
}

/// Capsule button with glass look
struct GlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.2), lineWidth: 1))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .shadow(color: .black.opacity(0.35), radius: 12, x: 0, y: 8)
    }
}
