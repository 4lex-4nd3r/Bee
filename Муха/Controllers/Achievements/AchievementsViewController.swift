//
//  AchievementsViewController.swift
//  Муха
//
//  Created by Александр on 21.09.2022.
//

import Foundation

import UIKit

class AchievementsViewController : UIViewController {

   // MARK: - Properties

   private let starsView1 = StarsView()
   private let starsView2 = StarsView()
   private let starsView3 = StarsView()
   private let starsView4 = StarsView()
   private var starsStack = UIStackView()

   // MARK: - Lifecycle

   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      setStars()
   }

   // MARK: - Setups

   private func setupViews() {
      view.backgroundColor = .systemBackground
      starsStack = UIStackView(arrangedSubviews: [starsView1,
                                                  starsView2,
                                                  starsView3,
                                                  starsView4])
      starsStack.axis = .vertical
      starsStack.distribution = .fillEqually
      starsStack.spacing = 20
      view.addSubview(starsStack)
      starsStack.snp.makeConstraints { make in
         make.width.equalTo(270)
         make.height.equalTo(400)
         make.centerY.centerX.equalToSuperview()
      }
   }

   private func setStars() {

      let statistic = StatisticManager.shared.getStatistic()

      let daysStreak = getDaysStreak(statistic: statistic)
      let stepsCount = getStepsCount(statistic: statistic)
      let timePlayed = getTimePlayed(statistic: statistic)
      let blindWin = getBlindWinCount(statistic: statistic)

      let starsLabel1 = S.Achievements.days + " \(daysStreak)"
      let starsLabel2 = S.Achievements.steps + " \(stepsCount)"
      let starsLabel3 = S.Achievements.time + " \(timePlayed)"
      let starsLabel4 = S.Achievements.blindCount + " \(blindWin)"

      starsView1.setStars(number: daysStreak.daysStars, text: starsLabel1)
      starsView2.setStars(number: stepsCount.stepsStars, text: starsLabel2)
      starsView3.setStars(number: timePlayed.timeStars, text: starsLabel3)
      starsView4.setStars(number: blindWin.winStars, text: starsLabel4)
   }

   private func getDaysStreak(statistic: [StatisticModel]) -> Int {

      guard var lastGameDate = statistic.first?.date else { return 1 }
      let isLastGameToday = Calendar.current.isDate(lastGameDate, inSameDayAs: Date())
      let isLastGameYesterDay = Calendar.current.isDate(lastGameDate.dayAfter, inSameDayAs: Date())

      if !isLastGameToday && !isLastGameYesterDay { return 0 }

      var streak = 1
      for game in statistic {
         let isDayBefore = Calendar
            .current
            .isDate(game.date.dayAfter, inSameDayAs: lastGameDate)
         let isSameDay = Calendar
            .current
            .isDate(game.date, inSameDayAs: lastGameDate)
         if isDayBefore {
            streak += 1
            lastGameDate = game.date
         } else if isSameDay {
            continue
         } else {
            break
         }
      }
      return streak
   }

   private func getStepsCount(statistic: [StatisticModel]) -> Int {
      var count = 0
      statistic.forEach { oneGame in
         count += oneGame.steps
      }
      return count
   }

   private func getTimePlayed(statistic: [StatisticModel]) -> Int {
      var time: Double = 0
      statistic.forEach { oneGame in
         time += (Double(oneGame.steps) * oneGame.speed)
      }
      return Int(time)
   }

   private func getBlindWinCount(statistic: [StatisticModel]) -> Int {
      var blindCount = 0
      statistic.forEach { oneGame in
         if oneGame.isWin && oneGame.isHide {
            blindCount += 1
         }
      }
      return blindCount
   }
}
