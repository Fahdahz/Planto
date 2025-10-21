//
//  Badges.swift
//  Planto
//
//  Created by Fahdah Alsamari on 29/04/1447 AH.
//

import SwiftUI

struct PillBadge: View {
    let icon: String
    let text: String
    var body: some View {
        Label(text, systemImage: icon)
            .font(.caption2)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.15), lineWidth: 1))
    }
}
