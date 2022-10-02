//
//  GameCollectionViewCell.swift
//  Муха
//
//  Created by Александр on 10.06.2022.
//

import UIKit
import SnapKit

class GameCollectionViewCell: UICollectionViewCell {

   let imageView: UIImageView = {
      let imageView = UIImageView()
      imageView.layer.cornerRadius = 15
      imageView.clipsToBounds = true
      imageView.contentMode = .scaleAspectFit
      return imageView
   }()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      backgroundColor = .systemGray3
      layer.cornerRadius = 15
      layer.borderWidth = 1
      addSubview(imageView)
      imageView.snp.makeConstraints { make in
         make.edges.equalToSuperview()
      }
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

   func setBee() {
      imageView.image = UIImage(named: "bigBee")
   }
}
