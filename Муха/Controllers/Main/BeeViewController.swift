//
//  MainViewController.swift
//  Муха
//
//  Created by Александр on 10.06.2022.
//

import UIKit
import AVFoundation
import RealmSwift

class BeeViewController: UIViewController {
   
   // MARK: - Properties
   
   private let defaults = UserDefaults.standard
   private var statisticModel = StatisticModel()

   private let collectionView = BeeCollectionView()
   
//   private let localRealm = try! Realm()
   
   //MARK: - UI Properties
   
   private lazy var statisticButton: UIButton = {
      let button = UIButton()
      button.setBackgroundImage(UIImage(systemName: "list.star"), for: .normal)
      button.addTarget(self, action: #selector(statisticButtonTapped), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
   }()
   
   private lazy var settingsButton: UIButton = {
      let button = UIButton()
      button.setBackgroundImage(UIImage(systemName: "gearshape"), for: .normal)
      button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
   }()
   
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
      button.setTitle("Старт", for: .normal)
      button.backgroundColor = .systemBlue
      button.layer.cornerRadius = 10
      button.translatesAutoresizingMaskIntoConstraints = false
      button.addTarget(self, action: #selector(startStopButtonTapped), for: .touchUpInside)
      return button
   }()
   
   //MARK: - Game Properties
   
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
   private var voice = "Даниил"
   
   // MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setupViews()
      setConstraints()
      setDelegates()
   }
   
   override func viewWillAppear(_ animated: Bool) {
//      print("apear")
      loadDefaults()
   }
   
   //MARK: - Setups
   
   private func setupViews() {
      view.backgroundColor = .systemBackground
      view.addSubview(collectionView)
      collectionView.isHidden = true
      collectionView.isUserInteractionEnabled = false
      view.addSubview(statisticButton)
      view.addSubview(settingsButton)
      view.addSubview(beeImage)
      view.addSubview(mainLabel)
      view.addSubview(startStopButton)
   }
   
   private func setDelegates() {
      collectionView.tapDelegate = self
   }
   
   private func loadDefaults() {
      if defaults.object(forKey: "steps") != nil {
//         print("load")
         steps = defaults.integer(forKey: "steps")
         speedInSec = defaults.double(forKey: "speedInSec")
         isHide = defaults.bool(forKey: "isHide")
         voice = defaults.string(forKey: "voice") ?? "Даниил"
      }
   }
   
   //MARK: - Selectors
   
   @objc private func statisticButtonTapped() {
      print("statisticButtonTapped")
      let statisticVC = StatisticViewController()
      statisticVC.modalPresentationStyle = .popover
      statisticVC.modalTransitionStyle = .coverVertical
      present(statisticVC, animated: true)
   }
   
   @objc private func settingsButtonTapped() {

      let settingsVC = SettingsViewController()
      navigationController?.pushViewController(settingsVC, animated: true)
      settingsVC.modalPresentationStyle = .fullScreen
      settingsVC.modalTransitionStyle = .coverVertical
//      present(settingsVC, animated: true)
   }
   
   @objc private func startStopButtonTapped() {
      
      if isStarted {
         testStop()
      } else {
         testStart()
      }
   }
   
   //MARK: - Game Stop
   
   private func testStop() {
      
      //change status of test
      isStarted = !isStarted
      
      //lock screen if needed
      UIApplication.shared.isIdleTimerDisabled = false

      //hide collectionView, show settings for game, show back button
      collectionView.isHidden = true
      mainLabel.text = ""
      statisticButton.isHidden = false
      settingsButton.isHidden = false
      beeImage.isHidden = false

      //change status of button
      startStopButton.backgroundColor = .systemBlue
      startStopButton.setTitle("Старт", for: .normal)
      
      //reset timers
      prepareTimer.invalidate()
      stepsTimer.invalidate()
   }
   
   //MARK: - Game Start

   private func testStart() {
      
      //change status of test
      isStarted = !isStarted
      
      //not lock screen
      UIApplication.shared.isIdleTimerDisabled = true
      
      //hide settings, hide back button - and show collectionView
      collectionView.isHidden = false
      statisticButton.isHidden = true
      settingsButton.isHidden = true
      beeImage.isHidden = true
      
      //change status of button
      startStopButton.backgroundColor = .systemRed
      startStopButton.setTitle("Стоп", for: .normal)
      
      //start test
      preparingTest()
   }
   
   //MARK: - Game Prepares
   
   private func preparingTest() {
      
      //choose random position of Bee
      x = Int.random(in: 0...4)
      y = Int.random(in: 0...4)
      
      //set Bee on view
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
                                        repeats: true) { timer in
         self.pickDirection()
         self.changePositionInXY()
         rounds += 1
         if rounds == self.steps {
            self.stepsTimer.invalidate()
            Timer.scheduledTimer(withTimeInterval: self.speedInSec, repeats: false) { timer in
               self.collectionView.index = IndexPath(item: self.y, section: self.x)
               print("x - \(self.x), y - \(self.y)")
               self.collectionView.isHidden = false
               self.playSound(with: self.voice + " - " + "Где муха?")
               self.mainLabel.text = "Где муха?"
               self.collectionView.isUserInteractionEnabled = true
            }
         }
      }
   }
   
   //MARK: - One Step of Bee
   
   private func pickDirection() {
      
      var array = ["влево", "вправо", "вверх", "вниз"]
      if x == 0 { array = array.filter{ $0 != "вверх"} }
      if x == 4 { array = array.filter{ $0 != "вниз"} }
      if y == 0 { array = array.filter{ $0 != "влево"} }
      if y == 4 { array = array.filter{ $0 != "вправо"} }
      movingDirection = array.randomElement()!
      let animation = CATransition()
      mainLabel.layer.add(animation, forKey: nil)
      mainLabel.text = movingDirection
      playSound(with: voice + " - " + movingDirection)
   }
   
   private func changePositionInXY() {
      switch movingDirection {
      case "влево": y -= 1
      case "вправо": y += 1
      case "вверх": x -= 1
      case "вниз": x += 1
      default: return
      }
   }
   
   private func playSound(with name: String) {
      guard let url = Bundle.main.url(forResource: name, withExtension:"mp3") else { return }
      player = try! AVAudioPlayer(contentsOf: url)
      do {
         try AVAudioSession.sharedInstance().setCategory(.playback)
      } catch(let error) {
         print(error.localizedDescription)
      }
      player.play()
   }
   
   //MARK: - Save Statistic
   
   private func saveResult(isWin: Bool) {
      
      statisticModel.date = Date()
      statisticModel.steps = steps
      statisticModel.speed = speedInSec
      statisticModel.isHide = isHide
      statisticModel.isWin = isWin
      StatisticManager.shared.saveResult(model: statisticModel)
      statisticModel = StatisticModel()
   }
   
   //MARK: - Constraints
   
   private func setConstraints() {
      
      NSLayoutConstraint.activate([
         collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
         collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
         collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
         collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, constant: 10)
      ])
      
      NSLayoutConstraint.activate([
      
         statisticButton.widthAnchor.constraint(equalToConstant: 30),
         statisticButton.heightAnchor.constraint(equalToConstant: 30),
         statisticButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
         statisticButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
      ])

      NSLayoutConstraint.activate([
         settingsButton.widthAnchor.constraint(equalToConstant: 30),
         settingsButton.heightAnchor.constraint(equalToConstant: 30),
         settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
         settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
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

extension BeeViewController: BeeCollectionViewProtocol {
   
   func checkResult(result: Bool) {
      
      playSound(with: voice + " - " + String(describing: result))
      saveResult(isWin: result)
      mainLabel.text = result ? "Верно!" : "Ошибка."
      let title = result ? "Верно!" : "Ошибка."
      let message = result ? "Поздравляем." : "Попробуйте еще."
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "ok", style: .default) { action in
         self.testStop()
      }
      alert.addAction(okAction)
      present(alert, animated: true)
   }
}




