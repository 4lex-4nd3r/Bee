//
//  UISwitch + .swift
//  Муха
//
//  Created by Александр on 18.09.2022.
//

import UIKit

extension UISwitch {
   
   convenience init(color: UIColor) {
      self.init()
      self.isOn = false
      self.onTintColor = .systemBlue
   }
}
