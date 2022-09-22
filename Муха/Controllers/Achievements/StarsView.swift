//
//  StarsView.swift
//  Муха
//
//  Created by Александр on 21.09.2022.
//

import Foundation
import UIKit
import SnapKit

class StarsView: UIView {

   // MARK: - Properties

   private let textLabel = UILabel(text: "", textAlignment: .center)
   private let star1 = UIImageView(image: UIImage(systemName: "star"))
   private let star2 = UIImageView(image: UIImage(systemName: "star"))
   private let star3 = UIImageView(image: UIImage(systemName: "star"))
   private let star4 = UIImageView(image: UIImage(systemName: "star"))
   private let star5 = UIImageView(image: UIImage(systemName: "star"))
   private var starsStack = UIStackView()

   // MARK: - Init

   override init(frame: CGRect) {
      super.init(frame: frame)
      setupViews()
      setConstraints()
   }

   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

   //MARK: - Setups

   private func setupViews() {
      backgroundColor = .systemGray6
      layer.cornerRadius = 10
      clipsToBounds = true
      starsStack = UIStackView(arrangedSubviews: [star1, star2, star3, star4, star5])
      starsStack.axis = .horizontal
      starsStack.spacing = 10
      starsStack.distribution = .fillEqually
      addSubview(starsStack)
      addSubview(textLabel)
   }

   func setStars(number: Int, text: String) {

      textLabel.text = text

      switch number {
      case 0: return
      case 1:
         star1.image = UIImage(systemName: "star.fill")
      case 2:
         star1.image = UIImage(systemName: "star.fill")
         star2.image = UIImage(systemName: "star.fill")
      case 3:
         star1.image = UIImage(systemName: "star.fill")
         star2.image = UIImage(systemName: "star.fill")
         star3.image = UIImage(systemName: "star.fill")
      case 4:
         star1.image = UIImage(systemName: "star.fill")
         star2.image = UIImage(systemName: "star.fill")
         star3.image = UIImage(systemName: "star.fill")
         star4.image = UIImage(systemName: "star.fill")
      case 5:
         star1.image = UIImage(systemName: "star.fill")
         star2.image = UIImage(systemName: "star.fill")
         star3.image = UIImage(systemName: "star.fill")
         star4.image = UIImage(systemName: "star.fill")
         star5.image = UIImage(systemName: "star.fill")
      default: return
      }
   }

   // MARK: - SetConstraints

   private func setConstraints() {

      textLabel.snp.makeConstraints { make in
         make.left.right.top.equalToSuperview().inset(10)
         make.height.equalTo(20)
      }

      starsStack.snp.makeConstraints { make in
         make.top.equalTo(textLabel.snp.bottom).inset(-10)
         make.left.right.bottom.equalToSuperview().inset(10)
         make.height.equalTo(30)
      }
   }
   
}
