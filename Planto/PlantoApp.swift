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
        NotificationManager.shared.scheduleDailyNotification(hour: 00, minute: 47) // 11:15 am
    }

    var body: some Scene {
        WindowGroup {
            PlantListView()
        }
    }
}
