//
//  DatePicker +.swift
//  Муха
//
//  Created by Александр on 18.09.2022.
//

import UIKit

extension UIDatePicker {
   
   convenience init(color: UIColor) {
      self.init()
      self.datePickerMode = .time
      self.isEnabled = false
   }
}
