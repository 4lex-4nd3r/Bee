//
//  GameViewModelProtocol.swift
//  Муха
//
//  Created by Александр on 30.09.2022.
//

import Foundation

protocol GameViewModelProtocol: AnyObject {

   var xPosition: Int { get }
   var yPosition: Int { get }

   
   var isHide: Bool { get }
   var steps: Int { get }
   var speedInSec: Double { get }
   var voice: String { get }

   var mainText: Box<String> { get }
   var isStarted: Box<Bool> { get }

   func startStopButtonTapped()
   func pickDirection()

   func loadDefaults()
   func playSound(with name: String)
   func saveResult(isWin: Bool)
}
