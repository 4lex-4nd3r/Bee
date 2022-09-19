//
//  StatisticManager.swift
//  Муха
//
//  Created by Александр on 28.07.2022.
//

import Foundation
import RealmSwift

class StatisticManager {
   
   static let shared = StatisticManager()
   private init() {}
   
   let localRealm = try! Realm()
   
   func saveResult(model: StatisticModel) {
      try! localRealm.write({
         localRealm.add(model)
      })
   }
   
   func deleteAllResults() {
      try! localRealm.write {
         localRealm.deleteAll()
      }
   }
   
   func getStatistic() -> [StatisticModel] {
      
      let statistic = Array(localRealm.objects(StatisticModel.self).sorted(byKeyPath: "date", ascending: false))
      print(statistic.count)
      return statistic
   }
}
