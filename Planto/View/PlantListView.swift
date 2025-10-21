//
//  PlantListView.swift
//  Planto
//
//  Created by Fahdah Alsamari on 29/04/1447 AH.
//

import SwiftUI

struct PlantListView: View {
    @StateObject private var vm = PlantListViewModel()

    // Sheet state
    @State private var form = PlantFormState()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // Title + divider (always visible)
                    VStack(spacing: 8) {
                        HStack {
                            Text("My Plants 🌱")
                                .font(.largeTitle).bold()
                            Spacer()
                        }
                        Divider()
                    }
                    .padding(.top, 8)

                    // ---- Empty vs. List ----
                    if vm.totalCount == 0 {
                        // FULL-PAGE START SCREEN (no card)
                        StartScreenView(onAdd: { startAdding() })
                    } else {
                        // WHEN WE HAVE PLANTS: show progress + list
                        if vm.allDone {
                            AllDoneHero()
                        } else {
                            WaitingBar(completed: vm.completedCount, total: vm.totalCount)
                        }

                        VStack(spacing: 10) {
                            ForEach(vm.plants) { plant in
                                PlantRow(
                                    plant: plant,
                                    onToggle: { vm.toggleDone(plant) },
                                    onEdit: { startEditing(plant) },
                                    onDelete: { vm.delete(plant) }
                                )
                            }
                        }
                        .padding(.top, 6)

                        Spacer(minLength: 100)
                    }
                }
                .padding(.horizontal, 16)
            }

            // Show the floating + ONLY after at least one plant exists
            if vm.totalCount > 0 {
                Button { startAdding() } label: {
                    Image(systemName: "plus")
                        .font(.title2.bold())
                        .padding(18)
                }
                .buttonStyle(GlassButtonStyle())
                .padding(20)
            }
        }
        // Present the sheet for add/edit (works in both empty & non-empty states)
        .sheet(isPresented: $vm.showingForm) {
            PlantFormSheet(
                mode: vm.formMode,
                form: $form,
                onSave: handleSave,
                onDelete: handleDeleteIfEditing
            )
            .presentationDetents([.medium, .large])
            .presentationBackground(.ultraThinMaterial)
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Sheet actions

    private func startAdding() {
        vm.formMode = .add(nil)
        form = PlantFormState()
        vm.showingForm = true                     // ← opens the sheet
    }

    private func startEditing(_ plant: Plant) {
        vm.formMode = .edit(plant)
        form = PlantFormState(from: plant)
        vm.showingForm = true
    }

    private func handleSave(_ mode: PlantListViewModel.FormMode, _ state: PlantFormState) {
        switch mode {
        case .add:
            vm.add(state.buildPlant())
        case .edit(let original):
            vm.update(state.buildPlant(editing: original.id, keepDone: true, original: original))
        }
        vm.showingForm = false                    // dismiss sheet
        // After dismiss: if it's the first plant, the UI automatically switches
        // from StartScreenView to the Today list and reveals the + button.
    }

    private func handleDeleteIfEditing(_ mode: PlantListViewModel.FormMode) {
        if case .edit(let p) = mode { vm.delete(p) }
        vm.showingForm = false
    }
}

// MARK: - Full-page start screen (no card)
private struct StartScreenView: View {
    var onAdd: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 20)

            // Illustration (use your asset name)
            Image("Plant")
                .resizable()
                .scaledToFit()
                .frame(height: 220)
                .shadow(radius: 12)

            VStack(spacing: 8) {
                Text("Start your plant journey!")
                    .font(.title2).bold()
                Text("Now all your plants will be in one place and we will help you take care of them 🪴")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Button {
                onAdd()                            // ← opens the sheet
            } label: {
                Text("Set Plant Reminder").font(.headline)
            }
            .buttonStyle(GlassButtonStyle())
            .tint(Color("GreenBtn"))               // or .green if no asset

            Spacer(minLength: 60)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

// MARK: - Small helpers for the non-empty state

private struct WaitingBar: View {
    let completed: Int
    let total: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your plants are waiting for a sip 💦")
                .font(.subheadline).foregroundStyle(.secondary)
            ProgressView(value: Double(completed), total: Double(max(total, 1)))
                .tint(.green)
        }
        .glass()
    }
}

private struct AllDoneHero: View {
    var body: some View {
        HStack(spacing: 16) {
            Image("PlantMascotWink") // optional; swap or remove if not available
                .resizable()
                .scaledToFit()
                .frame(height: 70)
            VStack(alignment: .leading, spacing: 6) {
                Text("All Done! 🎉").font(.title3).bold()
                Text("All Reminders Completed")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
        }
        .glass()
    }
}


#Preview {
    PlantListView()
}
