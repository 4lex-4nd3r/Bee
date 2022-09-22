//
//  GameCollectionView.swift
//  Муха
//
//  Created by Александр on 10.06.2022.
//

import UIKit

protocol GameCollectionViewProtocol: AnyObject {
   
   func checkResult(result: Bool)
}

class GameCollectionView: UICollectionView {
   
   // MARK: - Properties
   
   var cells = 5
   var index: IndexPath?
   
   // MARK: - Init

   override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
      super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
      configure()
   }

   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   // MARK: - Setups

   private func configure() {
      delegate = self
      dataSource = self
      backgroundColor = .none
      translatesAutoresizingMaskIntoConstraints = false
      register(GameCollectionViewCell.self, forCellWithReuseIdentifier: GameCollectionViewCell().idCell)
   }
   
   // MARK: - Methods
   
   func setupBee(x: Int, y: Int) {
      index = IndexPath(item: y, section: x)
      reloadData()
   }
   
   weak var tapDelegate: GameCollectionViewProtocol?
   
   private func sendResultToMainVC(result: Bool) {
      tapDelegate?.checkResult(result: result)
   }
   
}

// MARK: - UICollectionViewDelegate

extension GameCollectionView: UICollectionViewDelegate {
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      guard let index = index else { return }
      collectionView.isUserInteractionEnabled = false
      reloadData()
      if indexPath == index {
         sendResultToMainVC(result: true)
      } else {
         sendResultToMainVC(result: false)
      }
   }
}

// MARK: - UICollectionViewDataSource

extension GameCollectionView: UICollectionViewDataSource {
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      cells
   }
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      cells
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      guard let cell = collectionView
         .dequeueReusableCell(withReuseIdentifier: GameCollectionViewCell().idCell,
                              for: indexPath) as? GameCollectionViewCell else {
         return UICollectionViewCell()
      }
      
      if index != nil {
         if index! == indexPath {
            cell.setBee()
         } else {
            cell.imageView.image = nil
         }
      } else {
         cell.imageView.image = nil
      }
      return cell
   }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension GameCollectionView: UICollectionViewDelegateFlowLayout {
   
   func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       insetForSectionAt section: Int) -> UIEdgeInsets {
      let inset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
      return inset
   }
   
   func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      10
   }
   
   func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
      CGSize(width: (collectionView.frame.width - 40 ) / 5,
             height: (collectionView.frame.width - 40 ) / 5)
   }
}
