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

            VStack(alignment: .leading, spacing: 16) {

                
               // -- Today reminder screen
                VStack(spacing: 8) {
                    HStack {
                        Text("My Plants 🌱")
                            .font(.system(size: 34, weight: .bold))
                        Spacer()
                    }
                    Divider()
                        .frame(height: 1)
                        .background(Color.white.opacity(0.25))
                }
                .padding(.top, 8)
                .padding(.horizontal, 16)

                //Empty list
                if vm.totalCount == 0 {
                    StartScreenView(onAdd: { startAdding() })
                        .padding(.horizontal, 16)

                //All checked? -> All done screen
                } else if vm.allDone {
                    AllDoneScreen()
                        .padding(.top, 12)
                        .frame(maxWidth: .infinity)
                        .transition(.opacity)
                        .padding(.horizontal, 16)

                    Spacer(minLength: 120)

                } else {

                    WaitingBar(
                        completed: vm.completedCount,
                        total: vm.totalCount
                    )
                    .padding(.horizontal, 16)

                    // Checked plants goes down the list, Unchecked remains the same
                    // isDoneToday = false  -> Up
                    // isDoneToday = true -> goes down
                    let sortedPlants = vm.plants.sorted { a, b in
                        let aDone = a.isDoneToday
                        let bDone = b.isDoneToday
                        if aDone == bDone {
                            return true
                        }
                        return (aDone == false) && (bDone == true)
                    }

                    //List of plants with deviders between them
                    List {
                        ForEach(sortedPlants) { plant in
                            VStack(spacing: 0) {

                                PlantRow(
                                    plant: plant,
                                    onToggle: { vm.toggleDone(plant) },
                                    onEdit:   { startEditing(plant) },
                                    onDelete: { vm.delete(plant) }
                                )

                                if plant.id != sortedPlants.last?.id {
                                    Divider()
                                        .frame(height: 1)
                                        .background(Color.white.opacity(0.25))
                                }
                            }
                            .listRowBackground(Color.black)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 3, leading: 16, bottom: 6, trailing: 16))

                        }
                        .onDelete { offsets in
                            let idsToDelete = offsets.map { sortedPlants[$0].id }

                            for id in idsToDelete {
                                if let originalPlant = vm.plants.first(where: { $0.id == id }) {
                                    vm.delete(originalPlant)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.black)
                }

                Spacer(minLength: 0)
            }

            // + button to set new reminder
            if vm.totalCount > 0 {
                Button(action: startAdding) {
                    Image(systemName: "plus")
                        .font(.title2.bold())
                        .padding(12)
                        .frame(width: 20, height: 28)

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
            .presentationDetents([.large])
            .presentationDragIndicator(.hidden)
            .presentationBackground(.thinMaterial)
        }
        .preferredColorScheme(.dark)
        .background(Color.black.ignoresSafeArea())
    }

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


// -- Start your plant journey screen
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
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 15)

                Text("Now all your plants will be in one place and we will help you take care of them :) 🪴")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 10)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            

            Button(action: onAdd) {
                Text("Set Plant Reminder")
                    .font(.headline)
                    .frame(maxWidth: 300, minHeight: 35)
            }
            .buttonStyle(.glassProminent)
            .tint(Color("GreenBtn"))
            .padding(.top, 50)

            Spacer(minLength: 60)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
}


// -- All Done Screen
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

// -- Progress bar
private struct WaitingBar: View {
    let completed: Int
    let total: Int

    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            if completed == 0 {
                Text("Your plants are waiting for a sip 💦")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            } else {
                Text("\(completed) of your plants feel loved today ✨")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            ProgressView(
                value: Double(completed),
                total: Double(max(total, 1))
            )
            .tint(Color("GreenProg"))
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.black.opacity(0.6))
        )
    }
}

#Preview {
    PlantListView()
}
