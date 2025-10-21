//
//  PlantFormSheet.swift
//  Planto
//
//  Created by Fahdah Alsamari on 29/04/1447 AH.
//

import SwiftUI

struct PlantFormSheet: View {
    let mode: PlantListViewModel.FormMode
    @Binding var form: PlantFormState

    var onSave: (PlantListViewModel.FormMode, PlantFormState) -> Void
    var onDelete: (PlantListViewModel.FormMode) -> Void

    @Environment(\.dismiss) private var dismiss

    var title: String {
        switch mode {
        case .add: return "Set Reminder"
        case .edit: return "Edit Reminder"
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Plant Name", text: $form.name)
                        .textInputAutocapitalization(.words)
                        .submitLabel(.done)
                }
                .listRowBackground(GlassListBG())

                Section {
                    Picker("Room", selection: $form.room) {
                        ForEach(Room.allCases) { Text($0.rawValue).tag($0) }
                    }
                    Picker("Light", selection: $form.light) {
                        ForEach(LightLevel.allCases) { Text($0.rawValue).tag($0) }
                    }
                }
                .listRowBackground(GlassListBG())

                Section {
                    Picker("Watering Days", selection: $form.frequency) {
                        ForEach(WateringFrequency.allCases) { Text($0.rawValue).tag($0) }
                    }
                    TextField("Water (e.g. 20–50 ml)", text: $form.waterAmount)
                        .keyboardType(.numbersAndPunctuation)
                }
                .listRowBackground(GlassListBG())

                if case .edit = mode {
                    Section {
                        Button(role: .destructive) {
                            onDelete(mode)
                        } label: {
                            Text("Delete Reminder").frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .listRowBackground(GlassListBG())
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.opacity(0.6))
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: { Image(systemName: "xmark.circle.fill") }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        onSave(mode, form)
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .imageScale(.large)
                    }
                }
            }
        }
    }
}

// Glass look for Form rows
private struct GlassListBG: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.15)))
            .padding(.vertical, 6)
    }
}
