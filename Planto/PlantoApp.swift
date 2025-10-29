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
        NotificationManager.shared.scheduleDailyNotification(hour: 10, minute: 15) // 10:15
    }

    var body: some Scene {
        WindowGroup {
            PlantListView()
        }
    }
}
