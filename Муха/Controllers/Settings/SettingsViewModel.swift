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
   
   func changeIsHide(value: Bool)
   func changeSteps(value: Int)
   func changeSpeedInSec(value: Double)
   func changeVoice(value: String)
}

class SettingsViewModel: SettingsViewModelProtocol {

   init() {
      isHide = Box(value: defaults.bool(forKey: "isHide"))
      steps = Box(value: defaults.integer(forKey: "steps"))
      speedInSec = Box(value: defaults.double(forKey: "speedInSec"))
      voice = Box(value: defaults.string(forKey: "voice") ?? "Даниил")
   }
   
   private let defaults = UserDefaults.standard
      
   var isHide: Box<Bool>
   var steps: Box<Int>
   var speedInSec: Box<Double>
   var voice: Box<String>

   func changeIsHide(value: Bool) {
      isHide.value.toggle()
      defaults.set(value, forKey: "isHide")
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
}
