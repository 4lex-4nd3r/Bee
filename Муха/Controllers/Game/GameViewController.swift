//
//  GameViewController.swift
//  Муха
//
//  Created by Александр on 10.06.2022.
//

import UIKit
import AVFoundation
//import RealmSwift
import SnapKit

class GameViewController: UIViewController {
   
   // MARK: - Properties
   
   private let defaults = UserDefaults.standard
   private var statisticModel = StatisticModel()
   private let collectionView = GameCollectionView()

   // MARK: - UI Properties

   private lazy var statisticButton = UIButton(imageName: "list.star")
   private lazy var achievementsButton = UIButton(imageName: "star")
   private lazy var settingsButton = UIButton(imageName: "gearshape")

   private let beeImage: UIImageView = {
      let imageView = UIImageView()
      imageView.image = UIImage(named: "bigBee")
      imageView.contentMode = .scaleAspectFit
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
   }()

   private let mainLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 50)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()

   private lazy var startStopButton: UIButton = {
      let button = UIButton()
      button.setTitle(S.Game.start, for: .normal)
      button.backgroundColor = .systemBlue
      button.layer.cornerRadius = 10
      button.translatesAutoresizingMaskIntoConstraints = false
      button.addTarget(self, action: #selector(startStopButtonTapped), for: .touchUpInside)
      return button
   }()
   
   // MARK: - Game Properties

   private var isStarted = false
   private var player: AVAudioPlayer!

   private var x = 0
   private var y = 0
   private var movingDirection = ""
   private var time = 3
   
   private var prepareTimer = Timer()
   private var stepsTimer = Timer()

   private var isHide = false
   private var steps = 5
   private var speedInSec: Double = 1
   private var voice = S.Voices.man.fisrt

   // MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      setConstraints()
      setDelegates()
   }

   override func viewDidAppear(_ animated: Bool) {
      showOnboarding()
   }

   // MARK: - Setups
   
   private func setupViews() {
      view.backgroundColor = .systemBackground
      view.addSubview(statisticButton)
      statisticButton.addTarget(self,
                                action: #selector(statisticButtonTapped),
                                for: .touchUpInside)
      view.addSubview(achievementsButton)
      achievementsButton.addTarget(self,
                                action: #selector(achievementsButtonTapped),
                                for: .touchUpInside)
      view.addSubview(settingsButton)
      settingsButton.addTarget(self,
                                   action: #selector(settingsButtonTapped),
                                   for: .touchUpInside)

      view.addSubview(collectionView)
      collectionView.isHidden = true
      collectionView.isUserInteractionEnabled = false
      view.addSubview(beeImage)
      view.addSubview(mainLabel)
      view.addSubview(startStopButton)
   }

   private func setDelegates() {
      collectionView.tapDelegate = self
   }

   private func loadDefaults() {
      if defaults.object(forKey: "steps") != nil {
         steps = defaults.integer(forKey: "steps")
      }
      if defaults.object(forKey: "speedInSec") != nil {
         speedInSec = defaults.double(forKey: "speedInSec")
      }
      isHide = defaults.bool(forKey: "isHide")
      voice = defaults.string(forKey: "voice") ?? S.Voices.man.fisrt
      print(steps)
      print(speedInSec)
      print(voice)
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
      if isStarted {
         testStop()
      } else {
         testStart()
      }
   }

   // MARK: - Game Stop

   private func testStop() {

      // change status of test
      isStarted = !isStarted

      // lock screen if needed
      UIApplication.shared.isIdleTimerDisabled = false

      // hide collectionView, show settings for game, show back button
      collectionView.isHidden = true
      mainLabel.text = ""
      statisticButton.isHidden = false
      achievementsButton.isHidden = false
      settingsButton.isHidden = false
      
      beeImage.isHidden = false

      // change status of button
      startStopButton.backgroundColor = .systemBlue
      startStopButton.setTitle(S.Game.start, for: .normal)

      // reset timers
      prepareTimer.invalidate()
      stepsTimer.invalidate()
   }

   // MARK: - Game Start

   private func testStart() {

      loadDefaults()
      isStarted = !isStarted

      // not lock screen
      UIApplication.shared.isIdleTimerDisabled = true

      // hide settings, hide back button - and show collectionView
      collectionView.isHidden = false
      statisticButton.isHidden = true
      achievementsButton.isHidden = true
      settingsButton.isHidden = true
      beeImage.isHidden = true

      // change status of button
      startStopButton.backgroundColor = .systemRed
      startStopButton.setTitle(S.Game.stop, for: .normal)

      // start test
      preparingTest()
   }

   // MARK: - Game Prepares

   private func preparingTest() {

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
            self.collectionView.isHidden = self.isHide
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
      stepsTimer = Timer.scheduledTimer(withTimeInterval: speedInSec,
                                        repeats: true) { _ in
         self.pickDirection()
         self.changePositionInXY()
         rounds += 1
         if rounds == self.steps {
            self.stepsTimer.invalidate()
            Timer.scheduledTimer(withTimeInterval: self.speedInSec, repeats: false) { _ in
               self.collectionView.index = IndexPath(item: self.y, section: self.x)
               print("x - \(self.x), y - \(self.y)")
               self.collectionView.isHidden = false
               self.startStopButton.isHidden = true
               self.playSound(with: self.voice + " - " + S.Game.whereIsTheFly)
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
      playSound(with: voice + " - " + movingDirection)
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

   private func playSound(with name: String) {
      guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
      player = try! AVAudioPlayer(contentsOf: url)
      do {
         try AVAudioSession.sharedInstance().setCategory(.playback)
      } catch {
         print(error.localizedDescription)
      }
      player.play()
   }

   // MARK: - Save Statistic

   private func saveResult(isWin: Bool) {

      statisticModel.date = Date()
      statisticModel.steps = steps
      statisticModel.speed = speedInSec
      statisticModel.isHide = isHide
      statisticModel.isWin = isWin
      StatisticManager.shared.saveResult(model: statisticModel)
      statisticModel = StatisticModel()
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

      NSLayoutConstraint.activate([
         collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
         collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
         collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
         collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, constant: 10)
      ])

      NSLayoutConstraint.activate([
         beeImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
         beeImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
         beeImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
         beeImage.heightAnchor.constraint(equalTo: beeImage.widthAnchor)
      ])

      NSLayoutConstraint.activate([
         mainLabel.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -20),
         mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      ])

      NSLayoutConstraint.activate([
         startStopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
         startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         startStopButton.widthAnchor.constraint(equalToConstant: 250),
         startStopButton.heightAnchor.constraint(equalToConstant: 50)
      ])

   }
}

//MARK: - Result of Game

extension GameViewController: GameCollectionViewProtocol {
   
   func checkResult(result: Bool) {
      
      playSound(with: voice + " - " + String(describing: result))
      saveResult(isWin: result)
      mainLabel.text = result ? S.Game.correct : S.Game.wrong
      let title = result ? S.Game.correct : S.Game.wrong
      let message = result ? S.Game.correctMessage : S.Game.wrongMessage
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "ok", style: .default) { action in
         self.startStopButton.isHidden = false
         self.testStop()
      }
      alert.addAction(okAction)
      present(alert, animated: true)
   }
}




