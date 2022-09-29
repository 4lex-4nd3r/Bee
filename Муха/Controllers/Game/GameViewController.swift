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
   private let mainLabel = UILabel(size: 50, weight: .regular)
   private let beeImage: UIImageView = {
      let imageView = UIImageView()
      imageView.image = UIImage(named: "bigBee")
      imageView.contentMode = .scaleAspectFit
      return imageView
   }()
   private let startStopButton: UIButton = {
      let button = UIButton()
      button.setTitle(S.Game.start, for: .normal)
      button.backgroundColor = .systemBlue
      button.layer.cornerRadius = 10
      return button
   }()

   private var viewModel: GameViewModelProtocol!
   
   // MARK: - Game Properties

   private var isStarted = false

   private var x = 0
   private var y = 0
   private var movingDirection = ""
   private var time = 3
   
   private var prepareTimer = Timer()
   private var stepsTimer = Timer()

   // MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      viewModel = GameViewModel()
      setupViews()
      setConstraints()
   }

   override func viewDidAppear(_ animated: Bool) {
      showOnboarding()
   }

   // MARK: - Setups
   
   private func setupViews() {
      view.backgroundColor = .systemBackground
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
      isStarted ? testStop() : testStart()
   }

   // MARK: - Game Stop

   private func testStop() {
      UIApplication.shared.isIdleTimerDisabled = false
      isStarted.toggle()
      prepareTimer.invalidate()
      stepsTimer.invalidate()
      collectionView.isHidden = true
      mainLabel.text = ""
      statisticButton.isHidden = false
      achievementsButton.isHidden = false
      settingsButton.isHidden = false
      beeImage.isHidden = false
      startStopButton.backgroundColor = .systemBlue
      startStopButton.setTitle(S.Game.start, for: .normal)
   }

   // MARK: - Game Start

   private func testStart() {
      UIApplication.shared.isIdleTimerDisabled = true
      isStarted.toggle()
      collectionView.isHidden = false
      statisticButton.isHidden = true
      achievementsButton.isHidden = true
      settingsButton.isHidden = true
      beeImage.isHidden = true
      startStopButton.backgroundColor = .systemRed
      startStopButton.setTitle(S.Game.stop, for: .normal)
      preparingTest()
   }

   // MARK: - Game Prepares

   private func preparingTest() {

      viewModel.loadDefaults()

      // choose random position of Bee
      x = Int.random(in: 0...4)
      y = Int.random(in: 0...4)

      // set Bee on view
      collectionView.setupBee(x: x, y: y)

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
         self.pickDirection()
         self.changePositionInXY()
         rounds += 1
         if rounds == self.viewModel.steps {
            self.stepsTimer.invalidate()
            Timer.scheduledTimer(withTimeInterval: self.viewModel.speedInSec, repeats: false) { _ in
               self.collectionView.index = IndexPath(item: self.y, section: self.x)
               print("x - \(self.x), y - \(self.y)")
               self.collectionView.isHidden = false
               self.startStopButton.isHidden = true
               self.viewModel.playSound(with: S.Game.whereIsTheFly)
               self.mainLabel.text = S.Game.whereIsTheFly
               self.collectionView.isUserInteractionEnabled = true
            }
         }
      }
   }

   // MARK: - One Step of Bee

   private func pickDirection() {

      var array = [S.Game.left, S.Game.right, S.Game.up, S.Game.down]
      if x == 0 { array = array.filter { $0 != S.Game.up} }
      if x == 4 { array = array.filter { $0 != S.Game.down} }
      if y == 0 { array = array.filter { $0 != S.Game.left} }
      if y == 4 { array = array.filter { $0 != S.Game.right} }
      movingDirection = array.randomElement()!
      let animation = CATransition()
      mainLabel.layer.add(animation, forKey: nil)
      mainLabel.text = movingDirection
      viewModel.playSound(with: movingDirection)
   }

   private func changePositionInXY() {
      switch movingDirection {
      case S.Game.left: y -= 1
      case S.Game.right: y += 1
      case S.Game.up: x -= 1
      case S.Game.down: x += 1
      default: return
      }
   }

   // MARK: - Constraints

   private func setConstraints() {

      statisticButton.snp.makeConstraints { make in
         make.width.height.equalTo(30)
         make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
         make.left.equalToSuperview().inset(50)
      }

      achievementsButton.snp.makeConstraints { make in
         make.width.height.equalTo(30)
         make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
         make.centerX.equalToSuperview()
      }

      settingsButton.snp.makeConstraints { make in
         make.width.height.equalTo(30)
         make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
         make.right.equalToSuperview().inset(50)
      }

      collectionView.snp.makeConstraints { make in
         make.left.right.equalToSuperview().inset(10)
         make.centerY.equalToSuperview()
         make.height.equalTo(collectionView.snp.width).inset(-10)
      }

      beeImage.snp.makeConstraints { make in
         make.left.right.equalToSuperview().inset(40)
         make.centerY.equalToSuperview()
         make.height.equalTo(beeImage.snp.width)
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
      mainLabel.text = result ? S.Game.correct : S.Game.wrong
      alertOk(result: result) { [weak self] in
         guard let self = self else { return }
         self.startStopButton.isHidden = false
         self.testStop()
      }
   }
}
