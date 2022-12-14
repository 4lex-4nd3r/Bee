//
//  Date + .swift
//  Муха
//
//  Created by Александр on 21.09.2022.
//

import Foundation

extension Date {
   var dayAfter: Date {
      return Calendar.current.date(byAdding: .day, value: 1, to: self)!
   }

   var dayBefore: Date {
      return Calendar.current.date(byAdding: .day, value: -1, to: self)!
   }
}
