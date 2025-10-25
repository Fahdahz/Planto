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
                        .frame(width: 28, height: 28)
                }
            }
            .buttonStyle(.plain)

            // TAPPABLE CONTENT to open edit sheet
            Button(action: onEdit) {
                VStack(alignment: .leading, spacing: 8) {
                    Label("in \(plant.room.rawValue)", systemImage: "location")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(plant.name)
                        .font(.system(size: 28, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack(spacing: 8) {
                        Badge(
                            icon: "sun.max",
                            text: plant.light.rawValue,
                            bg: Color(.sRGB, red: 0.20, green: 0.20, blue: 0.10, opacity: 1),
                            fg: Color(red: 0.95, green: 0.90, blue: 0.55)
                        )

                        Badge(
                            icon: "drop",
                            text: plant.waterAmount.rawValue,
                            bg: Color(.sRGB, white: 0.18, opacity: 1),
                            fg: Color(.systemTeal)
                        )
                    }
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8) // simpler spacing for List rows
    }
}

// MARK: - Badge
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
        if UIColor(named: name) != nil {
            self = Color(name)
        } else {
            self = fallback
        }
    }
}
