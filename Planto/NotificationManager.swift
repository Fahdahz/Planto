//
//  NotificationManager.swift
//  Planto
//
//  Created by Fahdah Alsamari on 03/05/1447 AH.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    // Request permission once when the app launches
    func requestPermission() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                print("Notifications authorized")
            case .denied:
                print("Notifications denied")
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        print("Permission granted")
                    } else {
                        print("Permission denied")
                    }
                }
            default:
                break
            }
        }
    }

    // Schedule the notification
    func scheduleDailyNotification(hour: Int, minute: Int) {
        let identifier = "plant-reminder"
        let title = "Planto"
        let body = "Hey! let's water your plant"

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
        center.add(request)

        print("Daily notification scheduled at \(hour):\(minute)")
    }
}
