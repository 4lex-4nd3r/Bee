//
//  UIViewController + .swift
//  Муха
//
//  Created by Александр on 29.09.2022.
//

import Foundation

import UIKit

extension UIViewController {

   func alertOk(result: Bool, completion: @escaping () -> Void) {

      let title = result ? S.Game.correct : S.Game.wrong
      let message = result ? S.Game.correctMessage : S.Game.wrongMessage
      let alertController = UIAlertController(title: title,
                                              message: message,
                                              preferredStyle: .alert)
      let ok = UIAlertAction(title: "ok", style: .default) { action in
         completion()
      }
      alertController.addAction(ok)
      present(alertController, animated: true)
   }
}
