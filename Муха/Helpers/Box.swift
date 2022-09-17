//
//  Box.swift
//  Муха
//
//  Created by Александр on 17.09.2022.
//

import Foundation

class Box<T> {
   typealias Listener = (T) -> Void
   
   var listener: Listener?
   var value: T {
      didSet {
         listener?(value)
      }
   }
   
   init(value: T) {
      self.value = value
   }
   
   func bind(listener: @escaping Listener) {
      self.listener = listener
      listener(value)
   }
}
