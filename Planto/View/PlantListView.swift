//
//  PlantListView.swift
//  Planto
//
//  Created by Fahdah Alsamari on 29/04/1447 AH.
//

import SwiftUI

struct PlantListView: View {
    @StateObject private var vm = PlantListViewModel()
    @State private var form = PlantFormState()

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            // we cannot keep the ScrollView if we want swipe-to-delete,
            // because List must own the scrolling.
            VStack(alignment: .leading, spacing: 16) {

                // Title + divider
                VStack(spacing: 8) {
                    HStack {
                        Text("My Plants 🌱")
                            .font(.system(size: 34, weight: .bold))
                        Spacer()
                    }
                    Divider()
                        .frame(height: 1)
                        .background(Color.white.opacity(0.25)) // visible on dark
                }
                .padding(.top, 8)
                .padding(.horizontal, 16)

                // ---- Empty vs. All Done vs. List ----
                if vm.totalCount == 0 {
                    // First-run start screen (matches sketch)
                    StartScreenView(onAdd: { startAdding() })
                        .padding(.horizontal, 16)

                } else if vm.allDone {
                    // Full-screen celebration (no list)
                    AllDoneScreen()
                        .padding(.top, 12)
                        .frame(maxWidth: .infinity)
                        .transition(.opacity)

                    Spacer(minLength: 120) // room above floating +

                } else {
                    // Today reminder: progress + list

                    // waiting bar stays above the list
                    WaitingBar(
                        completed: vm.completedCount,
                        total: vm.totalCount
                    )
                    .padding(.horizontal, 16)

                    // THIS is the only real change:
                    // we render your rows inside a List with .onDelete
                    List {
                        ForEach(vm.plants) { plant in
                            VStack(spacing: 0) {
                                PlantRow(
                                    plant: plant,
                                    onToggle: { vm.toggleDone(plant) },
                                    onEdit:   { startEditing(plant) },
                                    onDelete: { vm.delete(plant) }
                                )

                                // custom divider, but not after the last item
                                if plant.id != vm.plants.last?.id {
                                    Divider()
                                        .frame(height: 1)
                                        .background(Color.white.opacity(0.25))
                                }
                            }
                            .listRowBackground(Color.black)
                            .listRowSeparator(.hidden)
                            .listSectionSeparator(.hidden, edges: .all) 
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let plant = vm.plants[index]
                                vm.delete(plant)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.black)


                }

                Spacer(minLength: 0)
            }

            // Show the floating + ONLY after at least one plant exists
            if vm.totalCount > 0 {
                Button(action: startAdding) {
                    Image(systemName: "plus")
                        .font(.title2.bold())
                        .frame(width: 20, height: 28)
                        .padding(8)
                }
                .buttonStyle(.glassProminent)
                .tint(Color("GreenBtn"))
                .padding(20)
            }
        }
        .sheet(isPresented: $vm.showingForm) {
            PlantFormSheet(
                mode: vm.formMode,
                form: $form,
                onSave: handleSave,
                onDelete: handleDeleteIfEditing
            )
            .presentationDetents([.large])          // full height sheet
            .presentationDragIndicator(.hidden)     // hide grabber
            .presentationBackground(.thinMaterial)  // lighter chrome
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Sheet actions
    private func startAdding() {
        vm.formMode = .add(nil)
        form = PlantFormState()
        vm.showingForm = true
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
            vm.update(
                state.buildPlant(
                    editing: original.id,
                    keepDone: true,
                    original: original
                )
            )
        }
        vm.showingForm = false
    }

    private func handleDeleteIfEditing(_ mode: PlantListViewModel.FormMode) {
        if case .edit(let p) = mode {
            vm.delete(p)
        }
        vm.showingForm = false
    }
}


// unchanged helper views below

private struct StartScreenView: View {
    var onAdd: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            Spacer(minLength: 10)

            Image("Plant")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .accessibilityHidden(true)
                .padding(50)

            VStack(spacing: 10) {
                Text("Start your plant journey!")
                    .font(.system(size: 28, weight: .semibold))
                    .padding(.bottom, 15)
                Text("Now all your plants will be in one place and we will help you take care of them :) 🪴")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 520)
                    .padding(.horizontal, 8)
            }
            .frame(maxWidth: .infinity, alignment: .center)

            Button(action: onAdd) {
                Text("Set Plant Reminder")
                    .font(.headline)
                    .frame(maxWidth: 300, minHeight: 35)
            }
            .buttonStyle(.glassProminent)       // Liquid Glass look
            .tint(Color("GreenBtn"))
            .padding(.top, 50)

            Spacer(minLength: 60)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

private struct AllDoneScreen: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 10)

            Image("PlantWink")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .shadow(radius: 12)
                .padding(.top, 70)

            Text("All Done! 🎉")
                .font(.title2).bold()

            Text("All Reminders Completed")
                .font(.callout)
                .foregroundStyle(.secondary)

            Spacer(minLength: 10)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 16)
    }
}

private struct WaitingBar: View {
    let completed: Int
    let total: Int

    // dynamic message based on completed count
    private var message: String {
        if total == 0 { return "" }
        if completed == 0 {
            return "Your plants are waiting for a sip 💦"
        } else {
            return "\(completed) of your plants feel loved today ✨"
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            ProgressView(value: Double(completed), total: Double(max(total, 1)))
                .tint(.green)
        }
        .glass()
    }
}



#Preview {
    PlantListView()
}
