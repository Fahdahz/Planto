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
    case bathroom = "Bathroom"
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
    case every3Days = "Every 3 days"
    case onceaweek = "Once a week"
    case tenDays = "Every 10 days"
    case biWeekly = "Every 2 weeks"
    var id: String { rawValue }
}

enum Water: String, CaseIterable, Codable, Identifiable {
    case quarter = "20-50 ml"
    case half = "50-100 ml"
    case third = "100-200 ml"
    case full = "200-300 ml"
    var id: String { rawValue }
}

struct Plant: Identifiable, Equatable, Codable {
    let id: UUID
    var name: String
    var room: Room
    var light: LightLevel
   
    var waterAmount: Water
    var frequency: WateringFrequency
    var isDoneToday: Bool

    init(
        id: UUID = UUID(),
        name: String,
        room: Room,
        light: LightLevel,
        waterAmount: Water,
        
        frequency: WateringFrequency,
        isDoneToday: Bool = false
    ) {
        self.id = id
        self.name = name
        self.room = room
        self.light = light
        self.waterAmount = waterAmount
        self.frequency = frequency
        self.isDoneToday = isDoneToday
    }
}
