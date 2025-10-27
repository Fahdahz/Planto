//
//  PlantFormState.swift
//  Planto
//
//  Created by Fahdah Alsamari on 29/04/1447 AH.
//

import Foundation

struct PlantFormState {
    var name: String = ""
    var room: Room = .bedroom
    var light: LightLevel = .high
    var frequency: WateringFrequency = .everyDay
    var waterAmount: Water = .quarter

    init() {}

    // Create a form pre-filled with an existing plant's data (for editing mode)
    init(from plant: Plant) {
        self.name = plant.name
        self.room = plant.room
        self.light = plant.light
        self.waterAmount = plant.waterAmount
        self.frequency = plant.frequency
    }

    // Builds a new or updated `Plant` instance based on the current form values.
    func buildPlant(editing id: UUID? = nil, keepDone: Bool = false, original: Plant? = nil) -> Plant {
        Plant(
            id: id ?? UUID(),
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            room: room,
            light: light,
            waterAmount: waterAmount,
            frequency: frequency,
            isDoneToday: keepDone ? (original?.isDoneToday ?? false) : false
        )
    }
}
