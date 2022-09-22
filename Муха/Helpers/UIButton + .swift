//
//  UIButton + .swift
//  Муха
//
//  Created by Александр on 21.09.2022.
//

import Foundation
import UIKit

extension UIButton {

   convenience init(imageName: String) {
      self.init()
      self.setBackgroundImage(UIImage(systemName: imageName), for: .normal)
   }
}
