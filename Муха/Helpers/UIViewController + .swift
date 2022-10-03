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


   func hideViewWithAnimation<T: UIView>(shouldHidden: Bool, view: T, time: Double) {
      if shouldHidden == true {
         UIView.animate(withDuration: time, animations: {
            view.alpha = 0
         }) { (finished) in
            view.isHidden = shouldHidden
         }
      } else {
//         view.alpha = 0
         view.isHidden = shouldHidden
         UIView.animate(withDuration: time) {
            view.alpha = 1
         }
      }
   }

   func hideTableWithAnimation<T: UIView>(shouldHidden: Bool, view: T) {
      if shouldHidden == true {
         UIView.animate(withDuration: 0.5, animations: {
            view.alpha = 0
         }) { (finished) in
            view.isHidden = shouldHidden
         }
      } else {
         view.alpha = 0
         view.isHidden = shouldHidden
         UIView.animate(withDuration: 0.5) {
            view.alpha = 0.7
         }
      }
   }

   func changeColorForButton<T:UIButton>(isDefault: Bool, button: T) {
      UIView.animate(withDuration: 0.5) {
         button.backgroundColor = isDefault ? .systemBlue : .systemRed
         button.setTitle((!isDefault ? S.Game.stop : S.Game.start), for: .normal)
      }
   }

   func hideBeeWithAnimation(hide: Bool) {

      
   }
}
