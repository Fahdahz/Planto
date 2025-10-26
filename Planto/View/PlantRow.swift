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
        VStack(alignment: .leading, spacing: 8) {

            // السطر اللي فيه المكان (in Bedroom...)
            HStack(spacing: 6) {
                Image(systemName: "location")
                    .foregroundStyle(.secondary)
                Text("in \(plant.room.rawValue)")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            HStack(alignment: .top, spacing: 12) {

                // زر الـ check
                Button(action: onToggle) {
                    if plant.isDoneToday {
                        ZStack {
                            Circle()
                                .fill(Color("GreenBtn", bundle: .main, default: .green))

                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black.opacity(0.9))
                        }
                        .frame(width: 28, height: 28)
                        // نفس إحساس صاحبتك: shadow فقط لما يكون متشيك
                        .shadow(
                            color: Color("GreenBtn", bundle: .main, default: .green).opacity(0.22),
                            radius: 8,
                            x: 0, y: 0
                        )
                    } else {
                        Circle()
                            .strokeBorder(Color(.systemGray3), lineWidth: 2)
                            .frame(width: 28, height: 28)
                    }
                }
                .buttonStyle(.plain)

                // باقي تفاصيل النبات (اسم + البادجات)
                VStack(alignment: .leading, spacing: 8) {

                    // اسم النبتة - لما أضغط عليه يفتح شاشة التعديل
                    Button(action: onEdit) {
                        Text(plant.name)
                            .font(.system(size: 28, weight: .semibold))
                            // لو متشيك نخلي اللون secondary زي في سكرين صاحبتك
                            .foregroundStyle(plant.isDoneToday ? .secondary : .primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.plain)

                    // البادجات (اللايت والمويه)
                    HStack(spacing: 8) {
                        Badge(
                            icon: "sun.max",
                            text: plant.light.rawValue,
                            bg: Color(.sRGB, red: 0.20, green: 0.20, blue: 0.10, opacity: 1),
                            fg: Color(.sRGB, red: 0.95, green: 0.90, blue: 0.55)
                        )

                        Badge(
                            icon: "drop",
                            text: plant.waterAmount.rawValue,
                            bg: Color(.sRGB, white: 0.18, opacity: 1),
                            fg: Color(.systemTeal)
                        )
                    }
                }
            }
        }
        .padding(.vertical, 8)
        // نخلي الصف كله tappable (نفس اللي تحبينه)
        .contentShape(Rectangle())
        .onTapGesture { onEdit() }
    }
}

// نفس الـ Badge حقتك بالضبط
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
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(bg)
        )
    }
}

// fallback للألوان المخصصة (زي ما هو عندك)
private extension Color {
    init(_ name: String, bundle: Bundle = .main, default fallback: Color) {
        if UIColor(named: name) != nil {
            self = Color(name)
        } else {
            self = fallback
        }
    }
}
