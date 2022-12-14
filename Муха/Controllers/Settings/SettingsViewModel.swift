//
//  SettingsViewModel.swift
//  Муха
//
//  Created by Александр on 16.09.2022.
//

import Foundation

protocol SettingsViewModelProtocol {

   var isHide: Box<Bool> { get }
   var steps: Box<Int> { get }
   var speedInSec: Box<Double> { get }
   var voice: Box<String> { get }
   var timer: Box<Date?> { get }
   var table: Box<Int> { get }

   func changeIsHide(value: Bool)
   func changeTable(value: Int)
   func changeSteps(value: Int)
   func changeSpeedInSec(value: Double)
   func changeVoice(value: String)
   func changeTimer(value: Date?)
}

class SettingsViewModel: SettingsViewModelProtocol {

   init() {
      isHide = Box(value: defaults.bool(forKey: "isHide"))
      table = Box(value: defaults.integer(forKey: "table"))
      let stepsValue = defaults.integer(forKey: "steps") == 0 ? 5 : defaults.integer(forKey: "steps")
      steps = Box(value: stepsValue)
      let speedValue = defaults.double(forKey: "speedInSec") == 0.0 ? 1.0 : defaults.double(forKey: "speedInSec")
      speedInSec = Box(value: speedValue)
      voice = Box(value: defaults.string(forKey: "voice") ?? S.Voices.man.fisrt)
      if let timerDate = defaults.object(forKey: "timer") as? Date {
         print("timer exist")
         timer = Box(value: timerDate)
      } else {
         print("no timer exist")
         timer = Box(value: nil)
      }
   }

   private let defaults = UserDefaults.standard
   private let notifications = NotificationsService()

   var isHide: Box<Bool>
   var steps: Box<Int>
   var speedInSec: Box<Double>
   var voice: Box<String>
   var timer: Box<Date?>
   var table: Box<Int>

   func changeIsHide(value: Bool) {
      isHide.value.toggle()
      defaults.set(value, forKey: "isHide")
   }

   func changeTable(value: Int) {
      table.value = value
      defaults.set(value, forKey: "table")
   }

   func changeSteps(value: Int) {
      steps.value = value
      defaults.set(value, forKey: "steps")
   }

   func changeSpeedInSec(value: Double) {
      speedInSec.value = value
      defaults.set(value, forKey: "speedInSec")
   }

   func changeVoice(value: String) {
      voice.value = value
      defaults.set(value, forKey: "voice")
   }

   func changeTimer(value: Date?) {
      if let value = value {
         timer.value = value
         defaults.set(value, forKey: "timer")
         print("set timer to defaults")
      } else {
         timer.value = nil
         defaults.removeObject(forKey: "timer")
         print("remove timer from defaults")
      }
      notifications.createScheduleLocal()
   }
}
