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
   
   private let speedLabel: UILabel = {
      let label = UILabel()
      label.text = "скорость"
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   
   private lazy var speedSlider: UISlider = {
      let slider = UISlider()
      slider.minimumValue = 1
      slider.maximumValue = 6
      slider.addTarget(self, action: #selector(speedSliderChangeValue), for: .valueChanged)
      slider.translatesAutoresizingMaskIntoConstraints = false
      return slider
   }()
   
   private let stepsLabel: UILabel = {
      let label = UILabel()
      label.text = "шаги"
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   
   private lazy var stepsSlider: UISlider = {
      let slider = UISlider()
      slider.minimumValue = 5
      slider.maximumValue = 50
      slider.addTarget(self, action: #selector(stepsSliderChangeValue), for: .valueChanged)
      slider.translatesAutoresizingMaskIntoConstraints = false
      return slider
   }()
   
   private let hideLabel: UILabel = {
      let label = UILabel()
      label.text = "спрятать таблицу"
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   
   private lazy var hideSwitch: UISwitch = {
      let hideSwitch = UISwitch()
      hideSwitch.translatesAutoresizingMaskIntoConstraints = false
      return hideSwitch
   }()
   
   private let voiceLabel: UILabel = {
      let label = UILabel()
      label.text = "выбрать голос"
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   
   private let voicePicker: UIPickerView = {
      let pickerView = UIPickerView()
      
      pickerView.translatesAutoresizingMaskIntoConstraints = false
      return pickerView
   }()
   
   
   private lazy var cancelButton: UIButton = {
      let button = UIButton()
      button.setTitle("Отменить", for: .normal)
      button.backgroundColor = .systemRed
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
         hideSwitch.setOn(isHide, animated: false)
      }
   }
   
   var steps = 5 {
      didSet {
         stepsLabel.text = "шаги = \(steps)"
         stepsSlider.value = Float(steps)
      }
   }
   var speedInSec: Double = 1 {
      didSet {
         speedLabel.text = "скорость = \(String(format: "%.1f", speedInSec)) секунд"
         speedSlider.value = Float(speedInSec)
      }
   }
   
   var voice = "Даниил" {
      didSet {
         print("set voice")
         print(voice)
      }
   }
   
   private var voices = ["Анна", "Дмитрий", "Даниил", "Алена", "Филипп", "Карина"]
   
   var player: AVAudioPlayer!

   
   // MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      setConstraints()
      setDelegates()
      loadDefaults()
      let index = voices.firstIndex(of: voice)
      if let index = index {
         voicePicker.selectRow(index, inComponent: 0, animated: true)
      }
   }

   //MARK: - Setups
   
   private func setupViews() {
      view.backgroundColor = .systemBackground
      view.addSubview(howToButton)
      view.addSubview(speedLabel)
      view.addSubview(speedSlider)
      view.addSubview(stepsLabel)
      view.addSubview(stepsSlider)
      view.addSubview(hideLabel)
      view.addSubview(hideSwitch)
      view.addSubview(voiceLabel)
      view.addSubview(voicePicker)
      buttonStack = UIStackView(arrangedSubviews: [cancelButton, saveButton])
      buttonStack.translatesAutoresizingMaskIntoConstraints = false
      buttonStack.spacing = 40
      buttonStack.axis = .horizontal
      buttonStack.distribution = .fillEqually
      view.addSubview(buttonStack)
      if isHide {
         hideSwitch.setOn(true, animated: false)
      } else {
         hideSwitch.setOn(false, animated: false)
      }
   }
   
   private func setDelegates() {
      voicePicker.delegate = self
      voicePicker.dataSource = self
   }
   
   private func loadDefaults() {
      if defaults.object(forKey: "steps") != nil {
         steps = defaults.integer(forKey: "steps")
         speedInSec = defaults.double(forKey: "speedInSec")
         isHide = defaults.bool(forKey: "isHide")
         voice = defaults.string(forKey: "voice") ?? "0"
      }
   }
   
   //MARK: - Selectors
   
   @objc private func speedSliderChangeValue() {
      speedInSec = Double(speedSlider.value)
   }
   
   @objc private func stepsSliderChangeValue() {
      steps = Int(stepsSlider.value)
   }
   
   @objc private func howToButtonTapped() {
      
      let message = """

Упражнение «Муха» развивает концентрацию внимания.

В начале упражнения, при нажатии кнопки «старт», в таблице в одной из клеток появляется муха. запомните ее положении, так как через три секунды она исчезнет. Диктор начнет произносить направления движения мухи, мысленно представляйте как муха перемещается по таблице. В момент, когда диктор спросит «где муха?», нажмите на клетку, в которой, по вашему мнению, она находится.

В опциях вы можете настроить сложность и длительность игры на свое усмотрение.
Ползунок «шаги» отвечает за то, сколько клеток муха пройдет, прежде чем диктор попросит вас указать на ее местоположение.
Ползунок «скорость» настраивает паузу между перемещениями, увеличивая время удержания внимания на одной клетке.
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
      delegate?.setOptions(steps: steps, speedInSec: speedInSec, isHide: hideSwitch.isOn, voice: voice)
      dismiss(animated: true)
   }
   
   private func saveToDefaults() {
      
      let steps = self.steps
      let speedInSec = self.speedInSec
      let isHide = self.hideSwitch.isOn
      let voice = self.voice
      
      defaults.set(steps, forKey: "steps")
      defaults.set(speedInSec, forKey: "speedInSec")
      defaults.set(isHide, forKey: "isHide")
      defaults.set(voice, forKey: "voice")
            
   }
   
   
   //MARK: - Constraints
   
   private func setConstraints() {
      
      
      NSLayoutConstraint.activate([
         howToButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
         howToButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         howToButton.widthAnchor.constraint(equalToConstant: 30),
         howToButton.heightAnchor.constraint(equalToConstant: 30)
      ])
      
      NSLayoutConstraint.activate([
         stepsLabel.topAnchor.constraint(equalTo: howToButton.bottomAnchor, constant: 50),
         stepsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      ])
      
      NSLayoutConstraint.activate([
         stepsSlider.topAnchor.constraint(equalTo: stepsLabel.bottomAnchor, constant: 5),
         stepsSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
         stepsSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
      ])
      
      NSLayoutConstraint.activate([
         speedLabel.topAnchor.constraint(equalTo: stepsSlider.bottomAnchor, constant: 10),
         speedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      ])
      
      NSLayoutConstraint.activate([
         speedSlider.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: 5),
         speedSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
         speedSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
      ])
      
      NSLayoutConstraint.activate([
         hideLabel.topAnchor.constraint(equalTo: speedSlider.bottomAnchor, constant: 40),
         hideLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40)
      ])
      
      NSLayoutConstraint.activate([
         hideSwitch.centerXAnchor.constraint(equalTo: voicePicker.centerXAnchor),
         hideSwitch.centerYAnchor.constraint(equalTo: hideLabel.centerYAnchor)
      ])
      
      NSLayoutConstraint.activate([
         voiceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
         voiceLabel.centerYAnchor.constraint(equalTo: voicePicker.centerYAnchor)
      ])
      
      NSLayoutConstraint.activate([
         voicePicker.topAnchor.constraint(equalTo: hideSwitch.bottomAnchor, constant: 20),
         voicePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
         voicePicker.widthAnchor.constraint(equalToConstant: 150)
      ])
      
      
      NSLayoutConstraint.activate([
         buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
         buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
         buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
         buttonStack.heightAnchor.constraint(equalToConstant: 40)
      ])
   }
}

extension SettingsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      1
   }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      voices.count
   }
   
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      voices[row]
   }
   
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      voice = voices[row]
      playSound(with: voices[row] + " - " + "Где муха?")
   }
   
   private func playSound(with name: String) {
      guard let url = Bundle.main.url(forResource: name, withExtension:"mp3") else { return }
      player = try! AVAudioPlayer(contentsOf: url)
      player.play()
   }
}
