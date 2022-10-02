//
//  Strings.swift
//  Муха
//
//  Created by Александр on 28.09.2022.
//

import Foundation

enum S {

   // MARK: - Voices
   enum Voices {

      enum man {
         static let fisrt = "Guy".localized()
         static let second = "Ryan".localized()
         static let third = "Arnold".localized()
      }

      enum woman {
         static let fisrt = "Kelsy".localized()
         static let second = "Aria".localized()
         static let third = "Mia".localized()
      }
   }

   // MARK: - Notification

   enum Notification {
      static let title = "Reminder".localized()
      static let body = "Time to practice".localized()
   }

   // MARK: - Cells ID

   enum CellsID {
      static let idOnboardingCell = "idOnboardingCell"
      static let idGameCell = "idGameCell"
      static let idStatisticCell = "idStatisticCell"
   }

   // MARK: - StatisticCell

   enum StatisticCell {
      static let label = "Statistic".localized()
      static let date = "Date ".localized()
      static let steps = "Steps - ".localized()
      static let speed = "Speed - ".localized()
      static let isHideYes = "Blind - Yes".localized()
      static let isHideNo = "Blind - No".localized()
   }

   // MARK: - Achievements

   enum Achievements {
      static let label = "Achievements".localized()
      static let days = "days played streak -".localized()
      static let steps = "fly's steps -".localized()
      static let time = "watching the fly -".localized()
      static let blindCount = "flies found blindly -".localized()
      static let min = "min".localized()
      static let sec = "sec".localized()
   }

   // MARK: - Settings Screen

   enum Settings {
      static let label = "Settings".localized()
      static let steps = "steps".localized()
      static let speed = "speed".localized()
      static let notification = "reminder".localized()
      static let showCells = "Show cells".localized()
      static let hideCells = "Hide cells".localized()
      static let whereIsTheFly = "Where's the fly?".localized()
   }

   enum Table {

      static let empty = "empty".localized()
      static let first = "table 1".localized()
      static let second = "table 2".localized()
      static let third = "table 3".localized()
   }

   // MARK: - Game

   enum Game {
      static let start = "Start".localized()
      static let stop = "Stop".localized()
      static let whereIsTheFly = "Where's the fly?".localized()
      static let left = "left".localized()
      static let right = "right".localized()
      static let up = "up".localized()
      static let down = "down".localized()
      static let correct = "That's right".localized()
      static let wrong = "Error".localized()
      static let correctMessage = "You're doing great!".localized()
      static let wrongMessage = "Try again.".localized()
   }
   
   // MARK: - OnBoarding Text

   enum OnBoardingText {
      static let next = "Next".localized()
      static let done = "Done".localized()
      static let page0 = "text for first screen".localized()
      static let page1 = "text for second screen".localized()
      static let page2 = "text for third screen".localized()
   }
}




