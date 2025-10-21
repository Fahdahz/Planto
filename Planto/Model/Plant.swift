//
//  Plant.swift
//  Planto
//
//  Created by Fahdah Alsamari on 29/04/1447 AH.
//

import Foundation

enum Room: String, CaseIterable, Codable, Identifiable {
    case bedroom = "Bedroom"
    case livingRoom = "Living Room"
    case kitchen = "Kitchen"
    case balcony = "Balcony"
    var id: String { rawValue }
}

enum LightLevel: String, CaseIterable, Codable, Identifiable {
    case low = "Low light"
    case medium = "Partial sun"
    case high = "Full sun"
    var id: String { rawValue }
}

enum WateringFrequency: String, CaseIterable, Codable, Identifiable {
    case everyDay = "Every day"
    case every2Days = "Every 2 days"
    case weekly = "Weekly"
    case biWeekly = "Every 2 weeks"
    var id: String { rawValue }
}

struct Plant: Identifiable, Equatable, Codable {
    let id: UUID
    var name: String
    var room: Room
    var light: LightLevel
    /// Show as e.g. "20–50 ml"
    var waterAmountLabel: String
    var frequency: WateringFrequency
    var isDoneToday: Bool

    init(
        id: UUID = UUID(),
        name: String,
        room: Room,
        light: LightLevel,
        waterAmountLabel: String,
        frequency: WateringFrequency,
        isDoneToday: Bool = false
    ) {
        self.id = id
        self.name = name
        self.room = room
        self.light = light
        self.waterAmountLabel = waterAmountLabel
        self.frequency = frequency
        self.isDoneToday = isDoneToday
    }
}
