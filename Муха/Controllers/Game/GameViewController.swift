//
//  GameViewController.swift
//  Муха
//
//  Created by Александр on 10.06.2022.
//

import UIKit
import SnapKit

class GameViewController: UIViewController {
   
   // MARK: - Properties

   private let collectionView = GameCollectionView()
   private lazy var statisticButton = UIButton(imageName: "list.star")
   private lazy var achievementsButton = UIButton(imageName: "star")
   private lazy var settingsButton = UIButton(imageName: "gearshape")
   private let mainLabel = UILabel(size: 50, weight: .bold)
   private let beeImage: UIImageView = {
      let imageView = UIImageView()
      imageView.image = UIImage(named: "bigBee")
      imageView.contentMode = .scaleAspectFit
      return imageView
   }()
   private lazy var startStopButton: UIButton = {
      let button = UIButton()
      button.setTitle(S.Game.start, for: .normal)
      button.titleLabel?.font = .systemFont(ofSize: 25)
      button.backgroundColor = .systemBlue
      button.layer.cornerRadius = 10
      button.layer.shadowColor = UIColor.black.cgColor
      button.layer.shadowRadius = 5
      button.layer.shadowOpacity = 0.5
      button.layer.shadowOffset = CGSize(width: 2, height: 2)
      button.layer.masksToBounds = false
      return button
   }()
   private let tableImageView: UIImageView = {
      let imageView = UIImageView()
      imageView.contentMode = .scaleAspectFill
      imageView.alpha = 0.7
      imageView.isHidden = true
      return imageView
   }()

   private var viewModel: GameViewModelProtocol!
   
   // MARK: - Timers

   private var time = 3
   private var prepareTimer = Timer()
   private var stepsTimer = Timer()

   // MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      viewModel = GameViewModel()
      setupViews()
      setupBind()
      setConstraints()
   }

   override func viewDidAppear(_ animated: Bool) {
      showOnboarding()
   }

   // MARK: - Setups
   
   private func setupViews() {
      view.backgroundColor = .systemBackground
      view.addSubview(tableImageView)
      view.addSubview(statisticButton)
      statisticButton.addTarget(self, action: #selector(statisticButtonTapped), for: .touchUpInside)
      view.addSubview(achievementsButton)
      achievementsButton.addTarget(self, action: #selector(achievementsButtonTapped), for: .touchUpInside)
      view.addSubview(settingsButton)
      settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
      view.addSubview(collectionView)
      collectionView.isHidden = true
      collectionView.isUserInteractionEnabled = false
      collectionView.tapDelegate = self
      view.addSubview(beeImage)
      view.addSubview(mainLabel)
      view.addSubview(startStopButton)
      startStopButton.addTarget(self, action: #selector(startStopButtonTapped), for: .touchUpInside)
   }

   private func setupBind() {
      viewModel.mainText.bind { [weak self] text in
         guard let self = self else { return }
         let animation = CATransition()
         self.mainLabel.layer.add(animation, forKey: nil)
         self.mainLabel.text = text
      }
      viewModel.table.bind { [weak self] table in
         guard let self = self else { return }
         self.tableImageView.image = (table == 0) ? nil : UIImage(named: "\(table)")
      }


      viewModel.isStarted.bind { [weak self] isStarted in
         guard let self = self else { return }
         UIApplication.shared.isIdleTimerDisabled = isStarted

         self.hideViewWithAnimation(shouldHidden: !isStarted, view: self.collectionView, time: 0.5)
         self.hideViewWithAnimation(shouldHidden: isStarted, view: self.statisticButton, time: 0.5)
         self.hideViewWithAnimation(shouldHidden: isStarted, view: self.achievementsButton, time: 0.5)
         self.hideViewWithAnimation(shouldHidden: isStarted, view: self.settingsButton, time: 0.5)
         self.hideTableWithAnimation(shouldHidden: !isStarted, view: self.tableImageView)
         self.changeColorForButton(isDefault: !isStarted, button: self.startStopButton)


         self.hideViewWithAnimation(shouldHidden: isStarted, view: self.beeImage, time: 0.5)
         //need animation for bee
//         self.beeImage.isHidden = isStarted

//         if isStarted {
//         let indexPath = IndexPath(item: self.viewModel.yPosition, section: self.viewModel.xPosition)
//
//         let cPoint = self.collectionView.layoutAttributesForItem(at: indexPath)?.center
//         print(cPoint!)
//
//         UIView.animate(withDuration: 3, animations: {
//
//            self.beeImage.snp.makeConstraints { make in
//               make.width.height.equalTo(50)
//               make.center.equalTo(cPoint!)
//            }
//         })
//         }


         if isStarted {
            self.preparingTest()
         } else {
            self.prepareTimer.invalidate()
            self.stepsTimer.invalidate()
            self.mainLabel.text = ""
         }
      }
   }

   private func showOnboarding() {
      if !OnboardStatus.shared.isOnboarded() {
         let onboardingVC = OnboardingViewController()
         onboardingVC.modalPresentationStyle = .fullScreen
         present(onboardingVC, animated: false)
      }
   }

   // MARK: - Selectors

   @objc private func statisticButtonTapped() {
      let statisticVC = StatisticViewController()
      present(statisticVC, animated: true)
   }

   @objc private func achievementsButtonTapped() {
      let achievementsVC = AchievementsViewController()
      present(achievementsVC, animated: true)
   }

   @objc private func settingsButtonTapped() {
      let settingsVC = SettingsViewController()
      present(settingsVC, animated: true)
   }

   @objc private func startStopButtonTapped() {
      viewModel.startStopButtonTapped()
   }

   // MARK: - Game Prepares


   private func preparingTest() {
      // set Bee on view
      collectionView.setupBee(x: viewModel.xPosition, y: viewModel.yPosition)




         //Frame Option 2:
         //self.myView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 4)
         //         self.myView.backgroundColor = .blue


      time = 3
      mainLabel.text = "\(time)"
      prepareTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
         self.time -= 1
         self.mainLabel.text = "\(self.time)"
         if self.time == -1 {
            self.collectionView.isHidden = self.viewModel.isHide
            self.mainLabel.text = ""
            self.prepareTimer.invalidate()
            self.collectionView.index = nil
            self.collectionView.reloadData()
            self.movingSteps()
         }
      }
   }

   //MARK: - Moving of Bee

   private func movingSteps() {

      var rounds = 0
      stepsTimer = Timer.scheduledTimer(withTimeInterval: viewModel.speedInSec,
                                        repeats: true) { _ in
         self.viewModel.pickDirection()
         rounds += 1
         if rounds == self.viewModel.steps {
            self.stepsTimer.invalidate()
            Timer.scheduledTimer(withTimeInterval: self.viewModel.speedInSec, repeats: false) { _ in
               self.collectionView.index = IndexPath(item: self.viewModel.yPosition,
                                                     section: self.viewModel.xPosition)
               self.collectionView.isHidden = false
               self.startStopButton.isHidden = true
               self.viewModel.playSound(with: S.Game.whereIsTheFly)
               self.mainLabel.text = S.Game.whereIsTheFly
               self.collectionView.isUserInteractionEnabled = true
            }
         }
      }
   }

   // MARK: - Constraints

   private func setConstraints() {

      tableImageView.snp.makeConstraints { make in
         make.edges.equalToSuperview()
      }

      statisticButton.snp.makeConstraints { make in
         make.width.height.equalTo(50)
         make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
         make.left.equalToSuperview().inset(50)
      }

      achievementsButton.snp.makeConstraints { make in
         make.width.height.equalTo(50)
         make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
         make.centerX.equalToSuperview()
      }

      settingsButton.snp.makeConstraints { make in
         make.width.height.equalTo(50)
         make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
         make.right.equalToSuperview().inset(50)
      }

      collectionView.snp.makeConstraints { make in
         make.left.right.equalToSuperview().inset(10)
         make.centerY.equalToSuperview()
         make.height.equalTo(collectionView.snp.width).inset(-10)
      }

      beeImage.snp.makeConstraints { make in
         make.height.width.equalTo(300)
         make.center.equalToSuperview()
      }

      mainLabel.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.bottom.equalTo(collectionView.snp.top).inset(-20)
      }

      startStopButton.snp.makeConstraints { make in
         make.centerX.equalToSuperview()
         make.width.equalTo(250)
         make.height.equalTo(50)
         make.bottom.equalToSuperview().inset(50)
      }
   }
}

//MARK: - Result of Game

extension GameViewController: GameCollectionViewProtocol {
   
   func checkResult(result: Bool) {
      viewModel.saveResult(isWin: result)
      viewModel.playSound(with: String(describing: result))
      alertOk(result: result) { [weak self] in
         guard let self = self else { return }
         self.startStopButton.isHidden = false
         self.viewModel.startStopButtonTapped()
      }
   }
}
