//
//  PlantListViewModel.swift
//  Planto
//
//  Created by Fahdah Alsamari on 29/04/1447 AH.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class PlantListViewModel: ObservableObject {
    @Published private(set) var plants: [Plant] = []
    @Published var showingForm = false
    @Published var formMode: FormMode = .add(nil)

    enum FormMode: Equatable {
        case add(Plant?)           // for potential defaults
        case edit(Plant)           // editing an existing
    }

    // MARK: - Derived stats
    var completedCount: Int { plants.filter { $0.isDoneToday }.count }
    var totalCount: Int { plants.count }
    var allDone: Bool { totalCount > 0 && completedCount == totalCount }

    // MARK: - CRUD
    func add(_ plant: Plant) {
        plants.append(plant)
    }

    func update(_ plant: Plant) {
        guard let idx = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[idx] = plant
    }

    func delete(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
    }

    func toggleDone(_ plant: Plant) {
        guard let idx = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[idx].isDoneToday.toggle()
    }


}
