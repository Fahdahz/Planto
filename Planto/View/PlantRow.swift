//
//  PlantRow.swift
//  Planto
//
//  Created by Fahdah Alsamari on 29/04/1447 AH.
//

import SwiftUI

struct PlantRow: View {
    let plant: Plant
    let onToggle: () -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                // circle checkbox
                Button(action: onToggle) {
                    Image(systemName: plant.isDoneToday ? "checkmark.circle.fill" : "circle")
                        .font(.title3)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("in \(plant.room.rawValue)")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(plant.name)
                        .font(.title3).bold()
                }

                Spacer()

                // quick edit button
                Button {
                    onEdit()
                } label: {
                    Image(systemName: "pencil")
                        .font(.body.bold())
                        .padding(8)
                }
                .buttonStyle(GlassButtonStyle())
            }

            HStack(spacing: 8) {
                PillBadge(icon: "sun.max.fill", text: plant.light.rawValue)
                PillBadge(icon: "drop.fill", text: plant.waterAmountLabel)
            }
        }
        .glass()
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) { onDelete() } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
