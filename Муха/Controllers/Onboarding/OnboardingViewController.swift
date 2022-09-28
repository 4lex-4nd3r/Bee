//
//  OnboardingViewController.swift
//  Муха
//
//  Created by Александр on 27.09.2022.
//

import UIKit
import SnapKit

class OnboardingViewController : UIViewController {

   // MARK: - Properties

   private let collectionView: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      layout.minimumLineSpacing = 0
      layout.scrollDirection = .horizontal
      let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
      collectionView.isScrollEnabled = false
      return collectionView
   }()

   private let idOnboardingCell = S.CellsID.idOnboardingCell

   private let onboardingText = [S.OnBoardingText.page0,
                                 S.OnBoardingText.page1,
                                 S.OnBoardingText.page2]

   private lazy var pageControl: UIPageControl = {
      let pageControl = UIPageControl()
      pageControl.currentPageIndicatorTintColor = .label
      pageControl.pageIndicatorTintColor = .systemGray3
      pageControl.numberOfPages = 3
      pageControl.transform = CGAffineTransform.init(scaleX: 1.25, y: 1.25)
      pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
      return pageControl
   }()

   private lazy var onboardButton: UIButton = {
      let button = UIButton()
      button.setTitle(S.OnBoardingText.next, for: .normal)
      button.backgroundColor = .systemBlue
      button.layer.cornerRadius = 10
      button.addTarget(self, action: #selector(onboardButtonPressed), for: .touchUpInside)
      return button
   }()

   // MARK: - Lifecycle

   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      setDelegates()
      setConstraints()
   }

   // MARK: - Setups

   private func setupViews() {
      view.backgroundColor = .systemBackground
      view.addSubview(collectionView)
      view.addSubview(pageControl)
      view.addSubview(onboardButton)
      collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: idOnboardingCell)
   }

   private func setDelegates() {
      collectionView.dataSource = self
      collectionView.delegate = self
   }

   // MARK: - Selectors

   @objc private func onboardButtonPressed() {

      if pageControl.currentPage == 1 {
         onboardButton.setTitle(S.OnBoardingText.done, for: .normal)
      }

      if pageControl.currentPage == 2 {
         OnboardStatus.shared.setToOnboarded()
         dismiss(animated: false, completion: nil)
      } else {
         pageControl.currentPage += 1
         let index: IndexPath = [0 , pageControl.currentPage]
         collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
      }
   }

   @objc private func pageControlValueChanged() {

      if pageControl.currentPage == 2 {
         onboardButton.setTitle(S.OnBoardingText.done, for: .normal)
      } else {
         onboardButton.setTitle(S.OnBoardingText.next, for: .normal)
      }
      let index: IndexPath = [0 , pageControl.currentPage]
      collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
   }


   // MARK: - Constraints

   private func setConstraints() {

      collectionView.snp.makeConstraints { make in
         make.left.right.equalToSuperview().inset(20)
         make.top.equalToSuperview().inset(40)
         make.bottom.equalTo(pageControl.snp.top).inset(-20)
      }

      pageControl.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.bottom.equalTo(onboardButton.snp.top).inset(-20)
      }

      onboardButton.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.width.equalTo(200)
         make.height.equalTo(50)
         make.bottom.equalToSuperview().inset(40)
      }
   }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
   }
}

// MARK: - UICollectionViewDataSource

extension OnboardingViewController: UICollectionViewDataSource {

   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      onboardingText.count
   }

   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: idOnboardingCell, for: indexPath) as? OnboardingCollectionViewCell else { return UICollectionViewCell() }
      let text = onboardingText[indexPath.row]
      cell.setText(text)
      return cell
   }
}
