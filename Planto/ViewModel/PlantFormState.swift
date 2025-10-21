//
//  PlantFormState.swift
//  Planto
//
//  Created by Fahdah Alsamari on 29/04/1447 AH.
//

import Foundation

/// Ephemeral state for the sheet fields
struct PlantFormState {
    var name: String = ""
    var room: Room = .bedroom
    var light: LightLevel = .high
    var waterAmount: String = "20–50 ml"
    var frequency: WateringFrequency = .everyDay

    init() {}

    init(from plant: Plant) {
        self.name = plant.name
        self.room = plant.room
        self.light = plant.light
        self.waterAmount = plant.waterAmountLabel
        self.frequency = plant.frequency
    }

    func buildPlant(editing id: UUID? = nil, keepDone: Bool = false, original: Plant? = nil) -> Plant {
        Plant(
            id: id ?? UUID(),
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            room: room,
            light: light,
            waterAmountLabel: waterAmount.trimmingCharacters(in: .whitespacesAndNewlines),
            frequency: frequency,
            isDoneToday: keepDone ? (original?.isDoneToday ?? false) : false
        )
    }
}
