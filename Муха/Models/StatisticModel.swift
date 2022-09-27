//
//  StatisticModel.swift
//  Муха
//
//  Created by Александр on 28.07.2022.
//

import Foundation
import RealmSwift

class StatisticModel: Object {
   
   @Persisted var date: Date
   @Persisted var steps: Int
   @Persisted var speed: Double
   @Persisted var isHide: Bool
   @Persisted var isWin: Bool
}
