//
//  CollectionView.swift
//  Муха
//
//  Created by Александр on 10.06.2022.
//

import UIKit

protocol BeeCollectionViewProtocol: AnyObject {
   
   func checkResult(result: Bool)
}

class BeeCollectionView : UICollectionView {
   
   // MARK: - Properties
   
   var cells = 0
   var index: IndexPath?
   
   override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
      super.init(frame: frame, collectionViewLayout: layout)
      configure()
   }
   
   convenience init(cells: Int) {
      self.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
      self.cells = cells
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   private func configure() {
      delegate = self
      dataSource = self
      backgroundColor = .none
      translatesAutoresizingMaskIntoConstraints = false
      register(BeeCollectionViewCell.self, forCellWithReuseIdentifier: BeeCollectionViewCell().idCell)
   }
   
   
   // MARK: - Lifecycle
   
   
   
   //MARK: - Setups
   
   private func setupViews() {
      
   }
   
   //MARK: - Selectors
   
   func setupBee(x: Int, y: Int) {
      index = IndexPath(item: y, section: x)
      print(index!)
      reloadData()
   }
   
   weak var tapDelegate: BeeCollectionViewProtocol?
   
   private func sendResultToMainVC(result: Bool) {
      tapDelegate?.checkResult(result: result)
   }
   
}

extension BeeCollectionView: UICollectionViewDelegate {
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      print(indexPath)
      collectionView.isUserInteractionEnabled = false
      reloadData()
      if indexPath == index! {
         sendResultToMainVC(result: true)
      } else {
         sendResultToMainVC(result: false)
      }
   }
   
}

extension BeeCollectionView: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      cells
   }
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      cells
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BeeCollectionViewCell().idCell, for: indexPath) as? BeeCollectionViewCell else {
         return UICollectionViewCell()
      }
      
      if index != nil {
         if index! == indexPath {
            cell.setBee()
         } else {
            cell.imageView.image = UIImage()
         }
      } else {
         cell.imageView.image = UIImage()
      }
      return cell
   }
}

extension BeeCollectionView: UICollectionViewDelegateFlowLayout {
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      let inset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
      return inset
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      CGSize(width: collectionView.frame.width / CGFloat(cells + 1),
             height: collectionView.frame.width / CGFloat(cells + 1))
   }
}
