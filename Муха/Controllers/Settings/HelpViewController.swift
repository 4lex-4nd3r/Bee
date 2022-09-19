//
//  HelpViewController.swift
//  Муха
//
//  Created by Александр on 19.09.2022.
//

import UIKit
import SnapKit

class HelpViewController : UIViewController {
   
   // MARK: - Properties
   
   private let helpTextView: UITextView = {
      let tv = UITextView()
      tv.font = .systemFont(ofSize: 16)
      tv.text = Help.text
      tv.isEditable = false
      tv.scrollRangeToVisible(NSMakeRange(0, 0))
      tv.scrollsToTop = true
      return tv
   }()
   
   // MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .systemBackground
      navigationItem.title = "Справка"
      view.addSubview(helpTextView)
      helpTextView.snp.makeConstraints { make in
         make.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
      }
   }

}
