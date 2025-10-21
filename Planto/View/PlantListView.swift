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
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                  
                    VStack(spacing: 8) {
                        HStack {
                            Text("My Plants 🌱")
                                .font(.system(size: 34, weight: .bold))   // large title
                            Spacer()
                        }
                        Divider().opacity(0.85)
                            .background(Color.white.opacity(0.70))
                    }
                    .padding(.top, 8)

                    // ---- Empty vs. List ----
                    if vm.totalCount == 0 {
                        StartScreenView(onAdd: { startAdding() })
                    } else {
                        // Progress / list screen (today reminder)
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
            vm.update(state.buildPlant(editing: original.id, keepDone: true, original: original))
        }
        vm.showingForm = false
    }

    private func handleDeleteIfEditing(_ mode: PlantListViewModel.FormMode) {
        if case .edit(let p) = mode { vm.delete(p) }
        vm.showingForm = false
    }
}

// MARK: - Full-page start screen (exactly like the sketch: no card)
private struct StartScreenView: View {
    var onAdd: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            Spacer(minLength: 10)

           
            Image("Plant")
                .resizable()
                .scaledToFit()
                .frame(height: 225)
                .accessibilityHidden(true)

            // Headline + paragraph
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

            // Solid green capsule button (like the sketch)
            Button(action: onAdd) {
                Text("Set Plant Reminder")
                    .font(.headline)
                    .frame(maxWidth: 300, minHeight: 35)
                
            }
            .buttonStyle(.glassProminent)
            .tint(Color("GreenBtn"))
            .padding(.top, 95)
            
            Spacer(minLength: 60)
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

// MARK: - Styles / helpers

/// solid green capsule (sketch look). Uses your "GreenBtn" color if present; falls back to a gradient.
private struct GreenCapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color("GreenBtn", bundle: .main, default: Color.green.opacity(0.90)),
                                Color("GreenBtn", bundle: .main, default: Color.green).opacity(0.75)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .foregroundStyle(.white)
            .overlay(
                Capsule().stroke(.white.opacity(0.15), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.35), radius: 16, x: 0, y: 10)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}

// convenience so Color("name", default:) works even if the asset is missing
private extension Color {
    init(_ name: String, bundle: Bundle = .main, default fallback: Color) {
        if let color = Color(named: name, in: bundle) { self = color } else { self = fallback }
    }
    // load optional asset color by name
    static func named(_ name: String, in bundle: Bundle = .main) -> Color? {
        guard UIImage(named: name, in: bundle, with: nil) != nil else { return nil }
        return Color(name)
    }
    init?(named name: String, in bundle: Bundle = .main) {
        guard UIImage(named: name, in: bundle, with: nil) != nil else { return nil }
        self.init(name)
    }
}

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
            Image("PlantMascotWink")
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
