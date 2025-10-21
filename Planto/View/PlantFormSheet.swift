//
//  PlantFormSheet.swift
//  Planto
//
//  Created by Fahdah Alsamari on 29/04/1447 AH.
//

import SwiftUI
import UIKit

struct PlantFormSheet: View {
    let mode: PlantListViewModel.FormMode
    @Binding var form: PlantFormState

    var onSave: (PlantListViewModel.FormMode, PlantFormState) -> Void
    var onDelete: (PlantListViewModel.FormMode) -> Void

    @Environment(\.dismiss) private var dismiss

    private var title: String {
        switch mode {
        case .add:  return "Set Reminder"
        case .edit: return "Edit Reminder"
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // lighter dark background (not pure black)
                Color(.sRGB, white: 0.12, opacity: 1).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 18) {

                        // HEADER (● X | Title | ✓ ●)
                        SheetHeader(
                            title: title,
                            onClose: { dismiss() },
                            onConfirm: { onSave(mode, form) }
                        )
                        .padding(.top, 8)

                        // GROUP 1 — Name
                        GlassGroup {
                            TextField("Plant Name", text: $form.name)
                                .textInputAutocapitalization(.words)
                                .submitLabel(.done)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 18)
                        }

                        // GROUP 2 — Room / Light  (Menu + Picker = iOS popup with ✓)
                        GlassGroup {
                            MenuPickerRow(
                                title: "Room",
                                systemImage: "location",
                                selectionText: form.room.rawValue
                            ) {
                                Picker("", selection: $form.room) {
                                    ForEach(Room.allCases) { Text($0.rawValue).tag($0) }
                                }
                            }

                            Divider().overlay(Color.white.opacity(0.12))

                            MenuPickerRow(
                                title: "Light",
                                systemImage: "sun.max",
                                selectionText: form.light.rawValue
                            ) {
                                Picker("", selection: $form.light) {
                                    ForEach(LightLevel.allCases) { Text($0.rawValue).tag($0) }
                                }
                            }
                        }

                        // GROUP 3 — Watering Days / Water
                        GlassGroup {
                            MenuPickerRow(
                                title: "Watering Days",
                                systemImage: "drop",
                                selectionText: form.frequency.rawValue
                            ) {
                                Picker("", selection: $form.frequency) {
                                    ForEach(WateringFrequency.allCases) { Text($0.rawValue).tag($0) }
                                }
                            }

                            Divider().overlay(Color.white.opacity(0.12))

                            MenuPickerRow(
                                title: "Water",
                                systemImage: "drop",
                                selectionText: form.waterAmount.rawValue
                            ) {
                                Picker("", selection: $form.waterAmount) {
                                    ForEach(Water.allCases) { Text($0.rawValue).tag($0) }
                                }
                            }
                        }

                        // Delete (edit only)
                        if case .edit = mode {
                            Button(role: .destructive) {
                                onDelete(mode)
                            } label: {
                                Text("Delete Reminder")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.red)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .padding(.top, 8)
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
            }
            .navigationBarHidden(true) // custom header
        }
    }
}

//
// MARK: - Header (round X and round green ✓)
//
private struct SheetHeader: View {
    var title: String
    var onClose: () -> Void
    var onConfirm: () -> Void

    var body: some View {
        HStack {
            CircleIconButton(systemName: "xmark", style: .dim, action: onClose)
            Spacer()
            Text(title).font(.headline)
            Spacer()
            CircleIconButton(systemName: "checkmark", style: .green, action: onConfirm)
        }
        .padding(.horizontal, 8)
    }
}

private struct CircleIconButton: View {
    enum Style { case dim, green }
    var systemName: String
    var style: Style
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(width: 38, height: 38)
                .background(background)
                .clipShape(Circle())
                .overlay(Circle().stroke(.white.opacity(0.15), lineWidth: 1))
                .shadow(color: .black.opacity(0.35), radius: 12, x: 0, y: 8)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(systemName == "xmark" ? "Close" : "Save")
    }

    @ViewBuilder
    private var background: some View {
        switch style {
        case .dim:
            Color.white.opacity(0.10)
        case .green:
            let g = Color.appGreen
            LinearGradient(colors: [g, g.opacity(0.85)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
        }
    }
}

//
// MARK: - Group container (glass look)
//
private struct GlassGroup<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        VStack(spacing: 0) { content }
            .padding(.horizontal, 6)
            .padding(.vertical, 6)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(.white.opacity(0.10), lineWidth: 1)
            )
    }
}

//
// MARK: - Menu + Picker row (native popup with ✓)
//
private struct MenuPickerRow<PickerContent: View>: View {
    var title: String
    var systemImage: String
    var selectionText: String
    @ViewBuilder var picker: PickerContent

    var body: some View {
        Menu {
            picker
        } label: {
            HStack {
                Label(title, systemImage: systemImage)
                    .foregroundStyle(.primary)
                Spacer()
                // match iOS row with trailing text + chevron-down indicator
                HStack(spacing: 6) {
                    Text(selectionText).foregroundStyle(.secondary)
                    Image(systemName: "chevron.down")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 14)
        }
        .menuStyle(.automatic)
        .tint(.primary) // keep label colors neutral (not blue)
    }
}

//
// MARK: - Color helper (uses asset "GreenBtn" if present)
//
private extension Color {
    static var appGreen: Color {
        if UIColor(named: "GreenBtn") != nil { return Color("GreenBtn") }
        return .green
    }
}
