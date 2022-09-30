//
//  GameViewModel.swift
//  Муха
//
//  Created by Александр on 16.09.2022.
//

import Foundation
import AVFoundation

// MARK: - View Model

class GameViewModel: GameViewModelProtocol {

   var xPosition: Int = 0
   var yPosition: Int = 0

   private let defaults = UserDefaults.standard
   private var player: AVAudioPlayer!

   func playSound(with string: String) {
      guard let url = Bundle.main.url(forResource: voice + " - " + string,
                                      withExtension: "mp3") else { return }
      player = try! AVAudioPlayer(contentsOf: url)
      do {
         try AVAudioSession.sharedInstance().setCategory(.playback)
      } catch {
         print(error.localizedDescription)
      }
      
      player.play()
   }

   var isHide = false
   var steps = 5
   var speedInSec: Double = 1
   var voice = S.Voices.man.fisrt

   var isStarted: Box<Bool> = Box(value: false)

   func startStopButtonTapped() {

      if !isStarted.value {
         loadDefaults()
         xPosition = Int.random(in: 0...4)
         yPosition = Int.random(in: 0...4)
      }
      isStarted.value.toggle()
   }

   func pickDirection() {
      var array = [S.Game.left, S.Game.right, S.Game.up, S.Game.down]
      if xPosition == 0 { array = array.filter { $0 != S.Game.up} }
      if xPosition == 4 { array = array.filter { $0 != S.Game.down} }
      if yPosition == 0 { array = array.filter { $0 != S.Game.left} }
      if yPosition == 4 { array = array.filter { $0 != S.Game.right} }
      let movingDirection = array.randomElement()!
      changePositionInXY(direction: movingDirection)
      mainText.value = movingDirection
      playSound(with: movingDirection)
   }

   func changePositionInXY(direction: String) {
      switch direction {
      case S.Game.left: yPosition -= 1
      case S.Game.right: yPosition += 1
      case S.Game.up: xPosition -= 1
      case S.Game.down: xPosition += 1
      default: return
      }
   }

   var mainText: Box<String> = Box(value: "")

   func loadDefaults() {
      if defaults.object(forKey: "steps") != nil { steps = defaults.integer(forKey: "steps") }
      if defaults.object(forKey: "speedInSec") != nil { speedInSec = defaults.double(forKey: "speedInSec") }
      isHide = defaults.bool(forKey: "isHide")
      voice = defaults.string(forKey: "voice") ?? S.Voices.man.fisrt
   }

   func saveResult(isWin: Bool) {
      mainText.value = isWin ? S.Game.correct : S.Game.wrong
      let statisticModel = StatisticModel()
      statisticModel.date = Date()
      statisticModel.steps = steps
      statisticModel.speed = speedInSec
      statisticModel.isHide = isHide
      statisticModel.isWin = isWin
      StatisticManager.shared.saveResult(model: statisticModel)
   }
}
