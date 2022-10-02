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
      self.layer.cornerRadius = 10
      self.backgroundColor = .systemBlue
      self.tintColor = .white
      self.setImage(UIImage(systemName: imageName), for: .normal)
      self.imageView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
      self.layer.shadowColor = UIColor.black.cgColor
      self.layer.shadowRadius = 5
      self.layer.shadowOpacity = 0.5
      self.layer.shadowOffset = CGSize(width: 2, height: 2)
   }
}
