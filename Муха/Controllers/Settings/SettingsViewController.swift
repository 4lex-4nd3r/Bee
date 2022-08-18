//
//  OptionsViewController.swift
//  Муха
//
//  Created by Александр on 16.06.2022.
//

import UIKit
import AVFoundation


protocol SettingsViewControllerProtocol: AnyObject {
   
   func setOptions(steps: Int, speedInSec: Double, isHide: Bool, voice: String)
}

class SettingsViewController : UIViewController {
   
   // MARK: - Properties
   
   private let defaults = UserDefaults.standard
   
   private lazy var howToButton: UIButton = {
      let button = UIButton()
      button.setBackgroundImage(UIImage(systemName: "questionmark.circle"), for: .normal)
      button.addTarget(self, action: #selector(howToButtonTapped), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
   }()
   
   private let stepsLabel: UILabel = {
      let label = UILabel()
      label.text = "шаги в раунде"
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   
   private let stepsCountLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 25, weight: .bold)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   
   private lazy var stepsStepper: UIStepper = {
      let stepper = UIStepper()
      stepper.minimumValue = 5
      stepper.maximumValue = 100
      stepper.stepValue = 5
      stepper.addTarget(self, action: #selector(stepsStepperValueChanged), for: .valueChanged)
      stepper.translatesAutoresizingMaskIntoConstraints = false
      return stepper
   }()
   
   private let speedLabel: UILabel = {
      let label = UILabel()
      label.text = "время"
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   
   private let speedCountLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 25, weight: .bold)
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()

   private lazy var speedStepper: UIStepper = {
      let stepper = UIStepper()
      stepper.minimumValue = 1
      stepper.maximumValue = 10
      stepper.stepValue = 0.5
      stepper.addTarget(self, action: #selector(speedStepperValueChanged), for: .valueChanged)
      stepper.translatesAutoresizingMaskIntoConstraints = false
      return stepper
   }()
   
   private let hideLabel: UILabel = {
      let label = UILabel()
      label.text = "отображение таблицы"
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   
   private lazy var hideSegmentControl: UISegmentedControl = {
      let control = UISegmentedControl(items: ["Показать", "Спрятать"])
      control.backgroundColor = .systemGray3
      control.selectedSegmentTintColor = .systemBlue
      control.setTitleTextAttributes([.foregroundColor : UIColor.systemBackground], for: .normal)
      control.setTitleTextAttributes([.foregroundColor : UIColor.systemBackground], for: .selected)
      control.addTarget(self, action: #selector(hideSegmentChanged), for: .valueChanged)
      control.translatesAutoresizingMaskIntoConstraints = false
      return control
   }()
   
   private let voiceLabel: UILabel = {
      let label = UILabel()
      label.text = "Голос"
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   
   private lazy var voiceSegmentedControl: UISegmentedControl = {
      
      let control = UISegmentedControl(items: ["Мужской", "Женский"])
      control.backgroundColor = .systemGray3
      control.selectedSegmentTintColor = .systemBlue
      control.setTitleTextAttributes([.foregroundColor : UIColor.systemBackground], for: .normal)
      control.setTitleTextAttributes([.foregroundColor : UIColor.systemBackground], for: .selected)
      control.addTarget(self, action: #selector(voiceSegmentedChanged), for: .valueChanged)
      control.translatesAutoresizingMaskIntoConstraints = false
      return control
   }()
   
   private let dictorLabel: UILabel = {
      let label = UILabel()
      label.text = "Диктор"
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   
   private lazy var dictorSegmentedControl: UISegmentedControl = {
      
      let control = UISegmentedControl(items: ["Анна", "Алена", "Карина"])
      control.backgroundColor = .systemGray3
      control.selectedSegmentTintColor = .systemBlue
      control.setTitleTextAttributes([.foregroundColor : UIColor.systemBackground], for: .normal)
      control.setTitleTextAttributes([.foregroundColor : UIColor.systemBackground], for: .selected)
      control.addTarget(self, action: #selector(dictorSegmentedChanged), for: .valueChanged)
      control.translatesAutoresizingMaskIntoConstraints = false
      return control
   }()
   
   private lazy var cancelButton: UIButton = {
      let button = UIButton()
      button.setTitle("Отменить", for: .normal)
      button.backgroundColor = .systemGray3
      button.layer.cornerRadius = 10
      button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
   }()
      
   private lazy var saveButton: UIButton = {
      let button = UIButton()
      button.setTitle("Сохранить", for: .normal)
      button.backgroundColor = .systemBlue
      button.layer.cornerRadius = 10
      button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
   }()
   
   var buttonStack = UIStackView()
   
   var isHide = false {
      didSet {
         hideSegmentControl.selectedSegmentIndex = isHide ? 1 : 0
      }
   }
   
   var steps = 5 {
      didSet {
         stepsCountLabel.text = "\(steps)"
         stepsStepper.value = Double(steps)
      }
   }
   var speedInSec: Double = 1 {
      didSet {
         speedCountLabel.text = "\(String(format: "%.1f", speedInSec))"
         speedStepper.value = Double(speedInSec)
      }
   }
   
   var voice = "Даниил" {
      didSet {
         setSegmentsIndex(for: voice)
      }
   }
   
   private func setSegmentsIndex(for voice: String) {
      
      switch voice {
      case "Анна" :
         voiceSegmentedControl.selectedSegmentIndex = 1
         dictorSegmentedControl.setTitle("Анна", forSegmentAt: 0)
         dictorSegmentedControl.setTitle("Алена", forSegmentAt: 1)
         dictorSegmentedControl.setTitle("Карина", forSegmentAt: 2)
         dictorSegmentedControl.selectedSegmentIndex = 0
      case "Алена" :
         voiceSegmentedControl.selectedSegmentIndex = 1
         dictorSegmentedControl.setTitle("Анна", forSegmentAt: 0)
         dictorSegmentedControl.setTitle("Алена", forSegmentAt: 1)
         dictorSegmentedControl.setTitle("Карина", forSegmentAt: 2)
         dictorSegmentedControl.selectedSegmentIndex = 1

      case "Карина" :
         voiceSegmentedControl.selectedSegmentIndex = 1
         dictorSegmentedControl.setTitle("Анна", forSegmentAt: 0)
         dictorSegmentedControl.setTitle("Алена", forSegmentAt: 1)
         dictorSegmentedControl.setTitle("Карина", forSegmentAt: 2)
         dictorSegmentedControl.selectedSegmentIndex = 2
         
      case "Даниил" :
         voiceSegmentedControl.selectedSegmentIndex = 0
         dictorSegmentedControl.setTitle("Даниил", forSegmentAt: 0)
         dictorSegmentedControl.setTitle("Дмитрий", forSegmentAt: 1)
         dictorSegmentedControl.setTitle("Филипп", forSegmentAt: 2)
         dictorSegmentedControl.selectedSegmentIndex = 0
      case "Дмитрий" :
         voiceSegmentedControl.selectedSegmentIndex = 0
         dictorSegmentedControl.setTitle("Даниил", forSegmentAt: 0)
         dictorSegmentedControl.setTitle("Дмитрий", forSegmentAt: 1)
         dictorSegmentedControl.setTitle("Филипп", forSegmentAt: 2)
         dictorSegmentedControl.selectedSegmentIndex = 1
      case "Филипп" :
         voiceSegmentedControl.selectedSegmentIndex = 0
         dictorSegmentedControl.setTitle("Даниил", forSegmentAt: 0)
         dictorSegmentedControl.setTitle("Дмитрий", forSegmentAt: 1)
         dictorSegmentedControl.setTitle("Филипп", forSegmentAt: 2)
         dictorSegmentedControl.selectedSegmentIndex = 2
      default :
         return
      }
   }
      
   var player: AVAudioPlayer!

   
   // MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      setConstraints()
      loadDefaults()
   }

   //MARK: - Setups
   
   private func setupViews() {
      view.backgroundColor = .systemBackground
      view.addSubview(howToButton)
      view.addSubview(stepsLabel)
      view.addSubview(stepsCountLabel)
      view.addSubview(stepsStepper)
      view.addSubview(speedLabel)
      view.addSubview(speedCountLabel)
      view.addSubview(speedStepper)
      view.addSubview(hideLabel)
      view.addSubview(hideSegmentControl)
      view.addSubview(voiceLabel)
      view.addSubview(voiceSegmentedControl)
      view.addSubview(dictorLabel)
      view.addSubview(dictorSegmentedControl)
      buttonStack = UIStackView(arrangedSubviews: [cancelButton, saveButton])
      buttonStack.translatesAutoresizingMaskIntoConstraints = false
      buttonStack.spacing = 40
      buttonStack.axis = .horizontal
      buttonStack.distribution = .fillEqually
      view.addSubview(buttonStack)
   }
   
   private func loadDefaults() {
      if defaults.object(forKey: "steps") != nil {
         steps = defaults.integer(forKey: "steps")
         speedInSec = defaults.double(forKey: "speedInSec")
         isHide = defaults.bool(forKey: "isHide")
         voice = defaults.string(forKey: "voice") ?? "Даниил"
      } else {
         steps = 5
         speedInSec = 1
         isHide = false
         voice = "Даниил"
      }
   }
   
   //MARK: - Selectors
   
   @objc private func hideSegmentChanged() {
      
      if hideSegmentControl.selectedSegmentIndex == 1 {
         isHide = true
      } else {
         isHide = false
      }
   }
   
   @objc private func voiceSegmentedChanged() {
     
      if voiceSegmentedControl.selectedSegmentIndex == 1 {
         dictorSegmentedControl.setTitle("Анна", forSegmentAt: 0)
         dictorSegmentedControl.setTitle("Алена", forSegmentAt: 1)
         dictorSegmentedControl.setTitle("Карина", forSegmentAt: 2)
         dictorSegmentedControl.selectedSegmentIndex = 0
         voice = "Анна"
      } else {
         dictorSegmentedControl.setTitle("Даниил", forSegmentAt: 0)
         dictorSegmentedControl.setTitle("Дмитрий", forSegmentAt: 1)
         dictorSegmentedControl.setTitle("Филипп", forSegmentAt: 2)
         dictorSegmentedControl.selectedSegmentIndex = 0
         voice = "Даниил"
      }
   }
   
   @objc private func dictorSegmentedChanged() {
      
      guard let selectedVoice = dictorSegmentedControl.titleForSegment(at: dictorSegmentedControl.selectedSegmentIndex) else { return }
      playSound(with: selectedVoice + " - " + "Где муха?")
      voice = selectedVoice
   }
   
      private func playSound(with name: String) {
         guard let url = Bundle.main.url(forResource: name, withExtension:"mp3") else { return }
         player = try! AVAudioPlayer(contentsOf: url)
         player.play()
      }
   
   @objc private func stepsStepperValueChanged() {
      steps = Int(stepsStepper.value)
   }
   
   @objc private func speedStepperValueChanged() {
      speedInSec = Double(speedStepper.value)
   }
   
   @objc private func howToButtonTapped() {
      
      let message = """

Упражнение «Муха» развивает концентрацию внимания.

В начале упражнения, при нажатии кнопки «старт», в таблице в одной из клеток появляется муха. запомните ее положении, так как через три секунды она исчезнет. Диктор начнет произносить направления движения мухи, мысленно представляйте как муха перемещается по таблице. В момент, когда диктор спросит «где муха?», нажмите на клетку, в которой, по вашему мнению, она находится.

В опциях вы можете настроить сложность и длительность игры на свое усмотрение.
Счетчик «шаги» отвечает за то, сколько клеток муха пройдет, прежде чем диктор попросит вас указать на ее местоположение.
Счетчик «время» настраивает паузу между перемещениями, увеличивая время удержания внимания на одной клетке.
Включив опцию "спрятать таблицу", таблица будет скрыта на протяжении всей игры.
"""
      let alert = UIAlertController(title: "Как играть?", message: message, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Понятно.", style: .default)
      
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = NSTextAlignment.left
      let messageText = NSAttributedString(
          string: message,
          attributes: [
              NSAttributedString.Key.paragraphStyle: paragraphStyle,
              NSAttributedString.Key.font: UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 14)
          ]
      )

      alert.setValue(messageText, forKey: "attributedMessage")
      
      alert.addAction(okAction)
      present(alert, animated: true)
   }
   
   @objc private func cancelButtonTapped() {
      dismiss(animated: true)
   }
   
   weak var delegate: SettingsViewControllerProtocol?
   
   @objc private func saveButtonTapped() {
      saveToDefaults()
      delegate?.setOptions(steps: steps, speedInSec: speedInSec, isHide: isHide, voice: voice)
      dismiss(animated: true)
   }
   
   private func saveToDefaults() {
      
      let steps = self.steps
      let speedInSec = self.speedInSec
      let isHide = self.isHide
      let voice = self.voice
      
      defaults.set(steps, forKey: "steps")
      defaults.set(speedInSec, forKey: "speedInSec")
      defaults.set(isHide, forKey: "isHide")
      defaults.set(voice, forKey: "voice")
   }
   
   
   //MARK: - Constraints
   
   private func setConstraints() {
      
      NSLayoutConstraint.activate([
         howToButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
         howToButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
         howToButton.widthAnchor.constraint(equalToConstant: 30),
         howToButton.heightAnchor.constraint(equalToConstant: 30)
      ])
      
      NSLayoutConstraint.activate([
         stepsLabel.topAnchor.constraint(equalTo: howToButton.bottomAnchor, constant: 50),
         stepsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
      ])
      
      NSLayoutConstraint.activate([
         stepsCountLabel.centerYAnchor.constraint(equalTo: stepsLabel.centerYAnchor),
         stepsCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      ])
      
      NSLayoutConstraint.activate([
         stepsStepper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
         stepsStepper.centerYAnchor.constraint(equalTo: stepsLabel.centerYAnchor)
      ])
      
      NSLayoutConstraint.activate([
         speedLabel.topAnchor.constraint(equalTo: stepsLabel.bottomAnchor, constant: 30),
         speedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
      ])
      
      NSLayoutConstraint.activate([
         speedCountLabel.centerYAnchor.constraint(equalTo: speedLabel.centerYAnchor),
         speedCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      ])
      
      NSLayoutConstraint.activate([
         speedStepper.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
         speedStepper.centerYAnchor.constraint(equalTo: speedLabel.centerYAnchor)
      ])
      
      NSLayoutConstraint.activate([
         hideLabel.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: 50),
         hideLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      ])
      
      NSLayoutConstraint.activate([
         hideSegmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
         hideSegmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
         hideSegmentControl.topAnchor.constraint(equalTo: hideLabel.bottomAnchor, constant: 10)
      ])

      NSLayoutConstraint.activate([
         voiceLabel.topAnchor.constraint(equalTo: hideSegmentControl.bottomAnchor, constant: 20),
         voiceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      ])
      
      NSLayoutConstraint.activate([
         voiceSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
         voiceSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
         voiceSegmentedControl.topAnchor.constraint(equalTo: voiceLabel.bottomAnchor, constant: 10)
      ])

      NSLayoutConstraint.activate([
      
         dictorLabel.topAnchor.constraint(equalTo: voiceSegmentedControl.bottomAnchor, constant: 10),
         dictorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      ])
      
      
      NSLayoutConstraint.activate([
         dictorSegmentedControl.topAnchor.constraint(equalTo: dictorLabel.bottomAnchor, constant: 10),
         dictorSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
         dictorSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
      ])
      
      NSLayoutConstraint.activate([
         buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
         buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
         buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
         buttonStack.heightAnchor.constraint(equalToConstant: 40)
      ])
   }
}
