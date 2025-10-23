//
//  PlantRow.swift
//  Planto
//
//  Created by Fahdah Alsamari on 29/04/1447 AH.
//

import SwiftUI

struct PlantRow: View {
    let plant: Plant
    var onToggle: () -> Void
    var onEdit: () -> Void
    var onDelete: () -> Void

    var body: some View {
        HStack(alignment: .center, spacing: 14) {

            // LEFT: toggle circle / green check
            Button(action: onToggle) {
                if plant.isDoneToday {
                    ZStack {
                        Circle()
                            .fill(Color("GreenBtn", bundle: .main, default: .green))
                            .frame(width: 28, height: 28)
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black.opacity(0.9))
                    }
                    .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 3)
                } else {
                    Circle()
                        .strokeBorder(Color(.systemGray3), lineWidth: 2)
                        .frame(width: 26, height: 26)
                }
            }
            .buttonStyle(.plain)

            // MIDDLE: content
            VStack(alignment: .leading, spacing: 8) {
                // room line
                Label("in \(plant.room.rawValue)", systemImage: "location")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                // name
                Text(plant.name)
                    .font(.system(size: 28, weight: .semibold))  // big like sketch
                    .frame(maxWidth: .infinity, alignment: .leading)

                // badges
                HStack(spacing: 8) {
                    Badge(icon: "sun.max",
                          text: plant.light.rawValue,
                          bg: Color(.sRGB, red: 0.20, green: 0.20, blue: 0.10, opacity: 1),
                          fg: Color(red: 0.95, green: 0.90, blue: 0.55)) // warm yellow

                    // waterAmount is non-optional → no if-let, no ?.
                    Badge(icon: "drop",
                          text: plant.waterAmount.rawValue,
                          bg: Color(.sRGB, white: 0.18, opacity: 1),
                          fg: Color(.systemTeal))
                }

            }

            // RIGHT: circular edit button
            Button(action: onEdit) {
                Image(systemName: "pencil")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.glass) // your Liquid Glass small style
            .clipShape(Circle())
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.regularMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(.white.opacity(0.08), lineWidth: 1)
        )
    }
}

// MARK: - Small capsule badge (icon + text)
private struct Badge: View {
    let icon: String
    let text: String
    let bg: Color
    let fg: Color

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
            Text(text)
                .font(.footnote).bold()
        }
        .foregroundStyle(fg)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(bg)
        )
    }
}

// convenience fallback
private extension Color {
    init(_ name: String, bundle: Bundle = .main, default fallback: Color) {
        if UIColor(named: name) != nil { self = Color(name) } else { self = fallback }
    }
}
