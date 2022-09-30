//
//  OnboardStatus.swift
//  Муха
//
//  Created by Александр on 27.09.2022.
//

import Foundation

class OnboardStatus {

   static let shared = OnboardStatus()
   private init() {}

   func isOnboarded() -> Bool {
      return UserDefaults.standard.bool(forKey: "isOnboarded")
   }

   func setToOnboarded() {
      UserDefaults.standard.set(true, forKey: "isOnboarded")
   }
}
