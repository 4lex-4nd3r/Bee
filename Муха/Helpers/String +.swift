//
//  String +.swift
//  Муха
//
//  Created by Александр on 28.09.2022.
//

import Foundation

extension String {

   func localized() -> String {
      NSLocalizedString(
         self,
         tableName: "Localizable",
         bundle: .main,
         value: self,
         comment: self)
   }
}
