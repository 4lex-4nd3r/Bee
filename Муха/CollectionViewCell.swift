//
//  CollectionViewCell.swift
//  Муха
//
//  Created by Александр on 10.06.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
   
   let idCell = "idCell"

   let imageView: UIImageView = {
      let imageView = UIImageView()
      imageView.translatesAutoresizingMaskIntoConstraints = false
      imageView.contentMode = .scaleAspectFit
      return imageView
   }()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      setupViews()
      setConstraints()
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   private func setupViews() {
      backgroundColor = .systemGray3
      layer.cornerRadius = 15
//      layer.bo
      addSubview(imageView)
   }

   
    func setBee() {
       imageView.image = UIImage(named: "bee")
   }
   
   private func setConstraints() {
      
      NSLayoutConstraint.activate([
         imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
         imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
         imageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
         imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
      ])
      
   }
}
