//
//  GameViewModel.swift
//  Муха
//
//  Created by Александр on 16.09.2022.
//

import Foundation
import AVFoundation

protocol GameViewModelProtocol: AnyObject {

   var isHide: Bool { get }
   var steps: Int { get }
   var speedInSec: Double { get }
   var voice: String { get }

   func loadDefaults()
   func playSound(with name: String)
   func saveResult(isWin: Bool)
}

class GameViewModel: GameViewModelProtocol {

   private let defaults = UserDefaults.standard
   private var player: AVAudioPlayer!
   
   func playSound(with string: String) {
      guard let url = Bundle.main.url(forResource: voice + " - " + string, withExtension: "mp3") else { return }
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

   func loadDefaults() {
      if defaults.object(forKey: "steps") != nil { steps = defaults.integer(forKey: "steps") }
      if defaults.object(forKey: "speedInSec") != nil { speedInSec = defaults.double(forKey: "speedInSec") }
      isHide = defaults.bool(forKey: "isHide")
      voice = defaults.string(forKey: "voice") ?? S.Voices.man.fisrt
   }

   func saveResult(isWin: Bool) {
      let statisticModel = StatisticModel()
      statisticModel.date = Date()
      statisticModel.steps = steps
      statisticModel.speed = speedInSec
      statisticModel.isHide = isHide
      statisticModel.isWin = isWin
      StatisticManager.shared.saveResult(model: statisticModel)
   }
}
