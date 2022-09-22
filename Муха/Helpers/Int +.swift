//
//  Int +.swift
//  Муха
//
//  Created by Александр on 22.09.2022.
//

import Foundation

extension Int {

   var daysStars: Int {
      switch self {
      case 0..<3: return 0
      case 3..<7: return 1
      case 7..<14: return 2
      case 14..<30: return 3
      case 30..<100: return 4
      case 100...: return 5
      default: return 0
      }
   }

   var stepsStars: Int {
      switch self {
      case 0..<100: return 0
      case 100..<300: return 1
      case 300..<1000: return 2
      case 1000..<3000: return 3
      case 3000..<10000: return 4
      case 10000...: return 5
      default: return 0
      }
   }

   var timeStars: Int {
      switch self {
      case 0..<600: return 0
      case 600..<1800: return 1
      case 1800..<7200: return 2
      case 7200..<21600: return 3
      case 21600..<86400: return 4
      case 86400...: return 5
      default: return 0
      }
   }

   var winStars: Int {
      switch self {
      case 0..<3: return 0
      case 3..<10: return 1
      case 10..<30: return 2
      case 30..<100: return 3
      case 100..<300: return 4
      case 300...: return 5
      default: return 0
      }
   }
}
