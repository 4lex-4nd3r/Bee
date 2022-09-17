//
//  UISegmentedControl +.swift
//  Муха
//
//  Created by Александр on 16.09.2022.
//

import UIKit

extension UISegmentedControl {
   
   convenience init(segments: [Any]?, color: UIColor) {
      self.init(items: segments)
      self.backgroundColor = .systemGray3
      self.selectedSegmentTintColor = color
      self.setTitleTextAttributes([.foregroundColor : UIColor.systemBackground], for: .normal)
      self.setTitleTextAttributes([.foregroundColor : UIColor.systemBackground], for: .selected)
   }
}
