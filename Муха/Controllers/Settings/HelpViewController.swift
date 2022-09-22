//
//  HelpViewController.swift
//  Муха
//
//  Created by Александр on 19.09.2022.
//

import UIKit
import SnapKit

class HelpViewController: UIViewController {
   
   // MARK: - Properties
   
   private let helpTextView: UITextView = {
      let textView = UITextView()
      textView.font = .systemFont(ofSize: 16)
      textView.text = Help.text
      textView.isEditable = false
      textView.scrollRangeToVisible(NSRange(location: 0, length: 0))
      textView.scrollsToTop = true
      return textView
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
