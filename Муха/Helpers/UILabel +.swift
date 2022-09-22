//
//  UILabel +.swift
//  Муха
//
//  Created by Александр on 16.09.2022.
//

import UIKit

extension UILabel {
   
   convenience init(text: String) {
      self.init()
      self.text = text
   }
   
   convenience init(size: CGFloat, weight: UIFont.Weight) {
      self.init()
      self.font = .systemFont(ofSize: size, weight: weight)
   }

   convenience init(text: String, textAlignment: NSTextAlignment) {
      self.init()
      self.text = text
      self.textAlignment = textAlignment
      self.adjustsFontSizeToFitWidth = true
   }
}
