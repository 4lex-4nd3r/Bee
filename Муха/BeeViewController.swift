//
//  MainViewController.swift
//  Муха
//
//  Created by Александр on 10.06.2022.
//

import UIKit
import AVFoundation

class BeeViewController: UIViewController {
   
   // MARK: - Properties
   
   let defaults = UserDefaults.standard
   
   private var collectionView = BeeCollectionView(cells: 5)
   
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
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
   }()
   
   
   private let label: UILabel = {
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
   
   var isStarted = false
   var player: AVAudioPlayer!
   
   var x = 0
   var y = 0
   var movingDirection = ""
   
   var time = 3
   
   var prepareTimer = Timer()
   var stepsTimer = Timer()
   
   var isHide = false 
   var steps = 5
   var speedInSec: Double = 1
   var voice = "Даниил"
   
   // MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      setConstraints()
      setDelegates()
      loadDefaults()
   }
   
   //MARK: - Setups
   
   private func setupViews() {
      view.backgroundColor = .systemBackground
      view.addSubview(collectionView)
      collectionView.isHidden = true
      collectionView.isUserInteractionEnabled = false
      view.addSubview(settingsButton)
      view.addSubview(beeImage)
      view.addSubview(label)
      view.addSubview(startStopButton)
   }
   
   private func setDelegates() {
      collectionView.tapDelegate = self
   }
   
   
   //MARK: - Selectors
   
   private func loadDefaults() {
      if defaults.object(forKey: "steps") != nil {
         print("load")
         steps = defaults.integer(forKey: "steps")
         speedInSec = defaults.double(forKey: "speedInSec")
         isHide = defaults.bool(forKey: "isHide")
      }
   }
   
   @objc private func settingsButtonTapped() {
      print("settingsButtonTapped")
      let settingsVC = SettingsViewController()
      settingsVC.delegate = self
//      settingsVC.steps = steps
//      settingsVC.speedInSec = speedInSec
//      settingsVC.isHide = isHide
//      settingsVC.voice = voice
      settingsVC.modalPresentationStyle = .fullScreen
      settingsVC.modalTransitionStyle = .coverVertical
      present(settingsVC, animated: true)
   }
   
   @objc private func startStopButtonTapped() {
      
      if isStarted {
         testStop()
      } else {
         testStart()
      }
   }
   
   private func testStop() {
      
      //change status of test
      isStarted = !isStarted
      
      //hide collectionView and show setting for game, show back button
      collectionView.isHidden = true
      label.text = ""
      settingsButton.isHidden = false
      beeImage.isHidden = false

      
      //change status of button
      startStopButton.backgroundColor = .systemBlue
      startStopButton.setTitle("Старт", for: .normal)
      
      //reset timers
      prepareTimer.invalidate()
      stepsTimer.invalidate()
   }
   
   private func testStart() {
      
      //change status of test
      isStarted = !isStarted
      
      //hide settings, hide back button - and show collectionView
      collectionView.isHidden = false
      settingsButton.isHidden = true
      beeImage.isHidden = true
      
      //change status of button
      startStopButton.backgroundColor = .systemRed
      startStopButton.setTitle("Стоп", for: .normal)
      
      //start test
      preparingTest()
   }
   
   private func preparingTest() {
      
      x = Int.random(in: 0...4)
      y = Int.random(in: 0...4)
      
      collectionView.setupBee(x: x, y: y)
      time = 3
      
      prepareTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
         self.label.text = "\(self.time)"
         self.time -= 1
         if self.time == -1 {
            self.collectionView.isHidden = self.isHide
            self.label.text = ""
            self.prepareTimer.invalidate()
            self.collectionView.index = nil
            self.collectionView.reloadData()
            self.movingSteps()
         }
      }
   }
   
   private func movingSteps() {
      
      var round = 0
      
      stepsTimer = Timer.scheduledTimer(withTimeInterval: speedInSec, repeats: true) { timer in
         
         self.pickDirection()
         self.changePositionInXY()
         round += 1
         
         if round == self.steps {
            self.stepsTimer.invalidate()
            Timer.scheduledTimer(withTimeInterval: self.speedInSec, repeats: false) { timer in
               self.collectionView.index = IndexPath(item: self.y, section: self.x)
               print("x - \(self.x), y - \(self.y)")
               self.collectionView.isHidden = false
               self.playSound(with: self.voice + " - " + "Где муха?")
               self.label.text = "Где муха?"
               self.collectionView.isUserInteractionEnabled = true
            }
         }
      }
   }
   
   private func pickDirection() {
      
      var array = ["влево", "вправо", "вверх", "вниз"]
      if x == 0 { array = array.filter{ $0 != "вверх"} }
      if x == 4 { array = array.filter{ $0 != "вниз"} }
      if y == 0 { array = array.filter{ $0 != "влево"} }
      if y == 4 { array = array.filter{ $0 != "вправо"} }
      movingDirection = array.randomElement()!
      let animation = CATransition()
      label.layer.add(animation, forKey: nil)
      label.text = movingDirection
      playSound(with: voice + " - " + movingDirection)
   }
   
   private func playSound(with name: String) {
      guard let url = Bundle.main.url(forResource: name, withExtension:"mp3") else { return }
      player = try! AVAudioPlayer(contentsOf: url)
      player.play()
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
   
   private func updateBeePositionInCollection() {
      collectionView.setupBee(x: x, y: y)
   }
   
   //MARK: - Constraints
   
   private func setConstraints() {
      
      NSLayoutConstraint.activate([
         collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
         collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
         collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
         collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor)
      ])

      NSLayoutConstraint.activate([
         settingsButton.widthAnchor.constraint(equalToConstant: 30),
         settingsButton.heightAnchor.constraint(equalToConstant: 30),
         settingsButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
         settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
      ])
      
      NSLayoutConstraint.activate([
         beeImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
         beeImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
         beeImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
         beeImage.heightAnchor.constraint(equalTo: beeImage.widthAnchor)
      ])

      NSLayoutConstraint.activate([
         label.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
         label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      ])
      
      NSLayoutConstraint.activate([
         startStopButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
         startStopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         startStopButton.widthAnchor.constraint(equalToConstant: 250),
         startStopButton.heightAnchor.constraint(equalToConstant: 50)
      ])
      
   }
}

extension BeeViewController: SettingsViewControllerProtocol {

   func setOptions(steps: Int, speedInSec: Double, isHide: Bool, voice: String) {
      self.steps = steps
      self.speedInSec = speedInSec
      self.isHide = isHide
      self.voice = voice
   }
}

extension BeeViewController: BeeCollectionViewProtocol {
   
   func checkResult(result: Bool) {
      
      playSound(with: voice + " - " + String(describing: result))
            
      label.text = result ? "Верно!" : "Ошибка."
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




