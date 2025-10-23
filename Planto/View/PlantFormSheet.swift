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
                // Lighter than pure black to match the mock
                Color(.sRGB, white: 0.12, opacity: 1).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 18) {

                       
                        HStack {
                            Button { dismiss() } label: {
                                Image(systemName: "xmark")
                                    .font(.headline)
                                    .frame(width: 38, height: 38)
                                    .clipShape(Circle())
                            }
                            .buttonStyle(.glass)                     // <- Liquid Glass
                            .tint(.white.opacity(0.22))              // dim, like the sketch)

                            Spacer()

                            Text(title)
                                .font(.headline)

                            Spacer()

                            Button { onSave(mode, form) } label: {
                                Image(systemName: "checkmark")
                                    .font(.headline)
                                    .frame(width: 38, height: 38)
                                    .clipShape(Circle())
                            }
                            .buttonStyle(.glassProminent)                     // <- Liquid Glass
                            .tint(Color("GreenBtn"))                 // same green as first page
                            
                        }
                        .padding(.horizontal, 8)

                    
                        // MARK: Group 1 — Plant Name (rounded field with WHITE placeholder)
                        GlassGroup {
                            PlaceholderTextField(
                                text: $form.name,
                                placeholder: "Plant Name",
                                placeholderColor: .white,
                                contentPadding: EdgeInsets(top: 14, leading: 18, bottom: 14, trailing: 18)
                            )
                            .textInputAutocapitalization(.words)
                            .submitLabel(.done)
                        }


                        // MARK: Group 2 — Room / Light (menu-style pickers with chevrons)
                        GlassGroup(spacing: 0) {
                            MenuPickerRow(
                                label: "Room",
                                systemImage: "location",
                                selection: $form.room,
                                all: Room.allCases.map { ($0.rawValue, $0) }
                            )

                            Divider().overlay(Color.white.opacity(0.12))

                            MenuPickerRow(
                                label: "Light",
                                systemImage: "sun.max",
                                selection: $form.light,
                                all: LightLevel.allCases.map { ($0.rawValue, $0) }
                            )
                        }

                        // MARK: Group 3 — Watering Days / Water
                        GlassGroup(spacing: 0) {
                            MenuPickerRow(
                                label: "Watering Days",
                                systemImage: "drop",
                                selection: $form.frequency,
                                all: WateringFrequency.allCases.map { ($0.rawValue, $0) }
                            )

                            Divider().overlay(Color.white.opacity(0.12))

                            MenuPickerRow(
                                label: "Water",
                                systemImage: "drop",
                                selection: $form.waterAmount,
                                all: Water.allCases.map { ($0.rawValue, $0) }
                            )
                        }

                        // Delete (edit mode only)
                        if case .edit = mode {
                            Button(role: .destructive) {
                                onDelete(mode)
                            } label: {
                                Text("Delete Reminder")
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                            }
                            .buttonStyle(.glass)                     // glass red looks great too
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
            .navigationBarHidden(true) // we draw our own header
        }
    }
}

// MARK: - Rounded “glass” group container
private struct GlassGroup<Content: View>: View {
    var spacing: CGFloat = 6
    @ViewBuilder var content: Content
    var body: some View {
        VStack(spacing: spacing) { content }
            .padding(.horizontal, 6)
            .padding(.vertical, 6)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(.white.opacity(0.10), lineWidth: 1)
            )
    }
}

// MARK: - White-placeholder TextField
private struct PlaceholderTextField: View {
    @Binding var text: String
    var placeholder: String
    var placeholderColor: Color = .white
    var contentPadding: EdgeInsets = .init()

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(placeholderColor)
                    .opacity(0.95)
                    .padding(contentPadding)
            }
            TextField("", text: $text)
                .padding(contentPadding)
        }
    }
}

// MARK: - Menu-style picker row (popup like iOS)
private struct MenuPickerRow<T: Hashable>: View {
    let label: String
    let systemImage: String
    @Binding var selection: T
    let all: [(String, T)] // display, value

    var body: some View {
        HStack {
            Label(label, systemImage: systemImage)

            Spacer(minLength: 8)

            Menu {
                ForEach(all, id: \.1) { pair in
                    Button {
                        selection = pair.1
                    } label: {
                        Label(pair.0, systemImage: selection == pair.1 ? "checkmark" : "")
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    // current selected text on the right
                    Text(display(for: selection))
                        .foregroundStyle(.secondary)
                    Image(systemName: "chevron.down")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
    }

    private func display(for value: T) -> String {
        all.first(where: { $0.1 == value })?.0 ?? ""
    }
}

