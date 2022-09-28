//
//  OnboardingCollectionViewCell.swift
//  Муха
//
//  Created by Александр on 27.09.2022.
//

import UIKit
import SnapKit

class OnboardingCollectionViewCell: UICollectionViewCell {

   // MARK: - Properties

   private let onboardingLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 18, weight: .medium)
      label.textAlignment = .center
      label.numberOfLines = 0
      return label
   }()

   // MARK: - Init

   override init(frame: CGRect) {
      super.init(frame: frame)
      addSubview(onboardingLabel)
      onboardingLabel.snp.makeConstraints { make in
         make.edges.equalToSuperview()
      }
   }

   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }

   func setText(_ text: String) {
      onboardingLabel.text = text
   }
}
