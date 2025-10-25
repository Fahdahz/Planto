//
//  PlantoApp.swift
//  Planto
//
//  Created by Fahdah Alsamari on 29/04/1447 AH.
//

import SwiftUI

@main
struct PlantoApp: App {
    init() {
        NotificationManager.shared.requestPermission()
        NotificationManager.shared.scheduleDailyNotification(hour: 13, minute: 45) // 1:45 pm
    }

    var body: some Scene {
        WindowGroup {
            PlantListView()
        }
    }
}
