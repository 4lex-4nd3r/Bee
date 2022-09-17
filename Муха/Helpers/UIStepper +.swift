//
//  UIStepper +.swift
//  Муха
//
//  Created by Александр on 16.09.2022.
//

import UIKit

extension UIStepper {
   
   convenience init(min: Double, max: Double, step: Double) {
      self.init()
      self.minimumValue = min
      self.maximumValue = max
      self.stepValue = step
   }
}
