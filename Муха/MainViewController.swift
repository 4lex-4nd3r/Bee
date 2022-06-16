//
//  MainViewController.swift
//  Муха
//
//  Created by Александр on 10.06.2022.
//

import UIKit
import AVFoundation

class MainViewController : UIViewController {
   
   // MARK: - Properties
   
   private var collectionView = CollectionView(cells: 5)
   
   private let label: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 50)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   
   private lazy var stopButton: UIButton = {
      let button = UIButton()
      button.setTitle("Стоп", for: .normal)
      button.backgroundColor = .systemRed
      button.alpha = 0.7
      button.isHidden = true
      button.layer.cornerRadius = 10
      button.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
   }()
      
   private lazy var startButton: UIButton = {
      let button = UIButton()
      button.setTitle("Старт", for: .normal)
      button.backgroundColor = .systemBlue
      button.layer.cornerRadius = 10
      button.translatesAutoresizingMaskIntoConstraints = false
      button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
      return button
   }()
   
   private lazy var optionsButton: UIButton = {
      let button = UIButton()
      button.setTitle("Опции", for: .normal)
      button.backgroundColor = .systemTeal
      button.layer.cornerRadius = 10
      button.translatesAutoresizingMaskIntoConstraints = false
      button.addTarget(self, action: #selector(optionsButtonTapped), for: .touchUpInside)
      return button
   }()
   
   var buttonStack = UIStackView()
   var player: AVAudioPlayer!

   var steps = 5
   var speedInSec: Double = 1
   var x = 0
   var y = 0
   var movingDirection = ""
   
   var time = 3 {
      didSet {
         label.text = "\(time)"
      }
   }
   
   
   
   var prepareTimer = Timer()
   var stepsTimer = Timer()
   
   
   // MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      setConstraints()
      setDelegates()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
   }
   
   //MARK: - Setups
   
   private func setupViews() {
      view.backgroundColor = .systemBackground
      view.addSubview(collectionView)
      view.addSubview(label)
      buttonStack = UIStackView(arrangedSubviews: [stopButton, startButton, optionsButton])
      buttonStack.translatesAutoresizingMaskIntoConstraints = false
      buttonStack.spacing = 40
      buttonStack.axis = .horizontal
      buttonStack.distribution = .fillEqually
      view.addSubview(buttonStack)
      collectionView.isUserInteractionEnabled = false
   }
   
   private func setDelegates() {
      collectionView.tapDelegate = self
   }

   
   //MARK: - Selectors
   
   @objc private func startButtonTapped() {
      
      freezeButtons(freeze: true)
      
      x = Int.random(in: 0...4)
      y = Int.random(in: 0...4)
      
      collectionView.setupBee(x: x, y: y)
      
      time = 3

      prepareTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
         self.time -= 1
         if self.time == -1 {
            self.label.text = ""
            self.prepareTimer.invalidate()
            self.collectionView.index = nil
            self.collectionView.reloadData()
            self.movingSteps()
         }
      }
   }
   
   @objc private func stopButtonTapped() {
      print("stopButtonTapped")
      prepareTimer.invalidate()
      stepsTimer.invalidate()
      freezeButtons(freeze: false)
      label.text = ""
   }
   
   @objc private func optionsButtonTapped() {
      
      let optionVC = OptionsViewController()
      optionVC.steps = steps
      optionVC.speedInSec = speedInSec
      optionVC.delegate = self
      present(optionVC, animated: true)
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
               self.playSound(with: "Где муха?")
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
      playSound(with: movingDirection)
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
   
   private func freezeButtons(freeze: Bool) {
      
      if freeze {
         startButton.isHidden = true
         optionsButton.isHidden = true
         stopButton.isHidden = false
      } else {
         startButton.isHidden = false
         optionsButton.isHidden = false
         stopButton.isHidden = true
      }
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
         label.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 40),
         label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      ])
      
      NSLayoutConstraint.activate([
         buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
         buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
         buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
         buttonStack.heightAnchor.constraint(equalToConstant: 40)
      ])
      

   }
}

extension MainViewController: CollectionViewProtocol {
   
   func checkResult(result: Bool) {
      
      label.text = result ? "Верно!" : "Ошибка."
      let title = result ? "Верно!" : "Ошибка."
      let message = result ? "Поздравляем." : "Попробуйте еще."
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "ok", style: .default)
      alert.addAction(okAction)
      present(alert, animated: true)
      
      freezeButtons(freeze: false)
   }
}

extension MainViewController: OptionsViewControllerProtocol {
   
   
   func setOptions(steps: Int, speedInSec: Double) {
      self.steps = steps
      self.speedInSec = speedInSec
      
      print(self.steps)
      print(self.speedInSec)
   }
   
   
}


