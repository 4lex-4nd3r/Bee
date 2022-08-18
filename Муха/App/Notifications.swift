//
//  Notifications.swift
//  Муха
//
//  Created by Александр on 26.07.2022.
//

import UIKit
import UserNotifications

class Notifications: NSObject {
   
   let notificationCenter = UNUserNotificationCenter.current()
   
   func requestAuth() {
      notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
         guard granted else { return }
         self.getNotificationSettings()
      }
   }
   
   func getNotificationSettings() {
      notificationCenter.getNotificationSettings { settings in
//         print(settings)
      }
   }
   
   func scheduleDateNotification() {
      
      let content = UNMutableNotificationContent()
      content.title = "Пора тренироваться."
      content.body = "Время пришло."
      content.sound = .default
      content.badge = 1
      
      let calendar = Calendar.current
      
      var triggerDate = calendar.dateComponents([.year, .month, .day], from: Date())
      triggerDate.hour = 13
      triggerDate.minute = 05
      
      
      let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
      
      
      let request = UNNotificationRequest(identifier: "id",
                                          content: content,
                                          trigger: trigger)
      
      notificationCenter.add(request)
   }
   
}

extension Notifications: UNUserNotificationCenterDelegate {
   
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      completionHandler([.alert, .sound, .badge])
   }
   
   func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      
      UIApplication.shared.applicationIconBadgeNumber = 0
      notificationCenter.removeAllDeliveredNotifications()
   }
}
