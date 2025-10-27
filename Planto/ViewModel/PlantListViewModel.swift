//
//  PlantListViewModel.swift
//  Planto
//
//  Created by Fahdah Alsamari on 29/04/1447 AH.

// View model that manages the list of plants.

import Foundation
import SwiftUI
import Combine

@MainActor
final class PlantListViewModel: ObservableObject {
    @Published private(set) var plants: [Plant] = []
    @Published var showingForm = false
    @Published var formMode: FormMode = .add(nil)

    enum FormMode: Equatable {
        case add(Plant?)
        case edit(Plant)
    }

    var completedCount: Int { plants.filter { $0.isDoneToday }.count }
    var totalCount: Int { plants.count }
    var allDone: Bool { totalCount > 0 && completedCount == totalCount }

    // Add a new plant to the list
    func add(_ plant: Plant) {
        plants.append(plant)
    }

    // Update an existing plant
    func update(_ plant: Plant) {
        guard let idx = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[idx] = plant
    }

    // Delete a specific plant
    func delete(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
    }

    // Toggle watering status (mark as done or not done)
    func toggleDone(_ plant: Plant) {
        guard let idx = plants.firstIndex(where: { $0.id == plant.id }) else { return }
        plants[idx].isDoneToday.toggle()
    }

}
