//
//  NotificationsService.swift
//  Муха
//
//  Created by Александр on 26.07.2022.
//

import UIKit
import UserNotifications

class NotificationsService: NSObject {
   
   let center = UNUserNotificationCenter.current()
   
   func requestAuth() {
      center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
         guard granted else { return }
         print("auth granted")
      }
   }

   func createScheduleLocal() {
   
      //проверка есть ли таймер
      guard let timerDate = UserDefaults.standard.object(forKey: "timer") as? Date else {
         addSchedule(request: nil)
         return
      }
      
      let content = UNMutableNotificationContent()
      content.title = "Напоминание"
      content.body = "Пришло время потренироваться"
      content.sound = .default
      content.badge = 1
      
      let calendar = Calendar.current
      let triggerTime = calendar.dateComponents([.hour, .minute], from: timerDate)
      let trigger = UNCalendarNotificationTrigger(dateMatching: triggerTime, repeats: true)
      let request = UNNotificationRequest(identifier: "timer",
                                          content: content,
                                          trigger: trigger)
      addSchedule(request: request)
   }
   
   private func addSchedule(request: UNNotificationRequest?) {
      center.removeAllDeliveredNotifications()
      center.removeAllPendingNotificationRequests()
      guard let request = request else {
         print("request deleted")
         return }
      center.add(request)
      print("request added")
   }
}

extension NotificationsService: UNUserNotificationCenterDelegate {
   
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      completionHandler([.alert, .sound])
   }
   
   func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      
      UIApplication.shared.applicationIconBadgeNumber = 0
      center.removeAllDeliveredNotifications()
   }
}
