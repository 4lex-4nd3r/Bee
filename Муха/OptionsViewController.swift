//
//  OptionsViewController.swift
//  Муха
//
//  Created by Александр on 16.06.2022.
//

import UIKit

protocol OptionsViewControllerProtocol: AnyObject {
   
   func setOptions(steps: Int, speedInSec: Double)
}

class OptionsViewController : UIViewController {
   
   // MARK: - Properties
   
   private lazy var howToButton: UIButton = {
      let button = UIButton()
      button.setTitle("Как играть?", for: .normal)
      button.backgroundColor = .systemBlue
      button.layer.cornerRadius = 10
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
   
   // MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      setConstraints()
   }
   
   //MARK: - Setups
   
   private func setupViews() {
      view.backgroundColor = .systemBackground
      view.addSubview(howToButton)
      view.addSubview(speedLabel)
      view.addSubview(speedSlider)
      view.addSubview(stepsLabel)
      view.addSubview(stepsSlider)
      buttonStack = UIStackView(arrangedSubviews: [cancelButton, saveButton])
      buttonStack.translatesAutoresizingMaskIntoConstraints = false
      buttonStack.spacing = 40
      buttonStack.axis = .horizontal
      buttonStack.distribution = .fillEqually
      view.addSubview(buttonStack)
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
   
   weak var delegate: OptionsViewControllerProtocol?
   
   @objc private func saveButtonTapped() {
      delegate?.setOptions(steps: steps, speedInSec: speedInSec)
      dismiss(animated: true)
      print("saveButtonTapped")
   }
   
   
   
   //MARK: - Constraints
   
   private func setConstraints() {
      
      
      NSLayoutConstraint.activate([
         howToButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
         howToButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         howToButton.widthAnchor.constraint(equalToConstant: 150),
         howToButton.heightAnchor.constraint(equalToConstant: 30)
      ])
      
      NSLayoutConstraint.activate([
         stepsLabel.topAnchor.constraint(equalTo: howToButton.bottomAnchor, constant: 50),
         stepsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      ])
      
      NSLayoutConstraint.activate([
         stepsSlider.topAnchor.constraint(equalTo: stepsLabel.bottomAnchor, constant: 5),
         stepsSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         stepsSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
      ])
      
      NSLayoutConstraint.activate([
         speedLabel.topAnchor.constraint(equalTo: stepsSlider.bottomAnchor, constant: 10),
         speedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      ])
      
      NSLayoutConstraint.activate([
         speedSlider.topAnchor.constraint(equalTo: speedLabel.bottomAnchor, constant: 5),
         speedSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
         speedSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
      ])
      
      NSLayoutConstraint.activate([
         buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
         buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
         buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
         buttonStack.heightAnchor.constraint(equalToConstant: 40)
      ])
   }
}
