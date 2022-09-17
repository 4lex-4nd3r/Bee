//
//  OptionsViewController.swift
//  Муха
//
//  Created by Александр on 16.06.2022.
//

import UIKit
import SnapKit
import AVFoundation

class SettingsViewController : UIViewController {
   
   // MARK: - views

   private let stepsLabel = UILabel(text: "шаги в раунде")
   private let stepsCountLabel = UILabel(size: 25, weight: .bold)
   private let speedLabel = UILabel(text: "время")
   private let speedCountLabel = UILabel(size: 25, weight: .bold)
   private let voiceLabel = UILabel(text: "Голос")
   private let hideLabel = UILabel(text: "отображение таблицы")
   private lazy var stepsStepper = UIStepper(min: 5, max: 100, step: 5)
   private lazy var speedStepper = UIStepper(min: 1, max: 10, step: 0.5)
   private lazy var hideSegmentControl = UISegmentedControl(segments: ["Показать", "Спрятать"], color: .systemBlue)
   private lazy var menSegmentedControl = UISegmentedControl(segments: ["Даниил", "Дмитрий", "Филипп"], color: .systemBlue)
   private lazy var womenSegmentedControl = UISegmentedControl(segments: ["Анна", "Алена", "Карина"], color: .systemPink)
   
   //MARK: - settings
   
   private var viewModel: SettingsViewModelProtocol!

   var player: AVAudioPlayer!
   
   // MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      setupTargets()
      viewModel = SettingsViewModel()
      setupBind()
      setConstraints()
   }

   //MARK: - Setups
   
   private func setupViews() {
      view.backgroundColor = .systemBackground
      let howToButton = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .done, target: self, action: #selector(howToButtonTapped))
      navigationItem.rightBarButtonItem = howToButton
      navigationItem.title = "Настройки"
      view.addSubview(stepsLabel)
      view.addSubview(stepsCountLabel)
      view.addSubview(stepsStepper)
      view.addSubview(speedLabel)
      view.addSubview(speedCountLabel)
      view.addSubview(speedStepper)
      view.addSubview(hideLabel)
      view.addSubview(hideSegmentControl)
      view.addSubview(voiceLabel)
      view.addSubview(menSegmentedControl)
      view.addSubview(womenSegmentedControl)
   }
   
   private func setupTargets() {
      stepsStepper.addTarget(self, action: #selector(stepsStepperValueChanged), for: .valueChanged)
      speedStepper.addTarget(self, action: #selector(speedStepperValueChanged), for: .valueChanged)
      hideSegmentControl.addTarget(self, action: #selector(hideSegmentChanged), for: .valueChanged)
      womenSegmentedControl.addTarget(self, action: #selector(womenSegmentedChanged), for: .valueChanged)
      menSegmentedControl.addTarget(self, action: #selector(menSegmentedChanged), for: .valueChanged)
   }
   
   private func setupBind() {
      
      viewModel.isHide.bind { [weak self] isHide in
         guard let self = self else { return }
         print("new value of isHide is - \(isHide)")
         self.hideSegmentControl.selectedSegmentIndex = isHide ? 1 : 0
      }
      
      viewModel.steps.bind { [weak self] steps in
         guard let self = self else { return }
         print("new value of steps is - \(steps)")
         self.stepsCountLabel.text = "\(steps)"
         self.stepsStepper.value = Double(steps)
      }
      
      viewModel.speedInSec.bind { [weak self] speedInSec in
         guard let self = self else { return }
         print("new value of speed is - \(speedInSec)")
         self.speedCountLabel.text = "\(String(format: "%.1f", speedInSec))"
         self.speedStepper.value = Double(speedInSec)
      }
      
      viewModel.voice.bind { [weak self] voice in
         guard let self = self else { return }
         print("new value of voice is - \(voice)")
         self.setSegmentsIndex(for: voice)
      }
   }
   
   private func setSegmentsIndex(for voice: String) {
      
      //need refactor with enums
      switch voice {
      case "Анна" :
         womenSegmentedControl.selectedSegmentIndex = 0
      case "Алена" :
         womenSegmentedControl.selectedSegmentIndex = 1
      case "Карина" :
         womenSegmentedControl.selectedSegmentIndex = 2
      case "Даниил" :
         menSegmentedControl.selectedSegmentIndex = 0
      case "Дмитрий" :
         menSegmentedControl.selectedSegmentIndex = 1
      case "Филипп" :
         menSegmentedControl.selectedSegmentIndex = 2
      default :
         return
      }
   }

   //MARK: - Selectors
   
   @objc private func stepsStepperValueChanged() {
      viewModel.changeSteps(value: Int(stepsStepper.value))
   }
   
   @objc private func speedStepperValueChanged() {
      viewModel.changeSpeedInSec(value: Double(speedStepper.value))
   }
   
   @objc private func hideSegmentChanged() {
      viewModel.changeIsHide(value: hideSegmentControl.selectedSegmentIndex == 1)
   }
   
   @objc private func womenSegmentedChanged() {
      guard let voice = womenSegmentedControl.titleForSegment(at: womenSegmentedControl.selectedSegmentIndex) else { return }
      menSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
      voiceChanged(voice: voice)
   }
   
   @objc private func menSegmentedChanged() {
      guard let voice = menSegmentedControl.titleForSegment(at: menSegmentedControl.selectedSegmentIndex) else { return }
      womenSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
      voiceChanged(voice: voice)
   }
   
   private func voiceChanged(voice: String) {
      viewModel.changeVoice(value: voice)
      playSound(with: voice + " - " + "Где муха?")
   }
   
   private func playSound(with name: String) {
      guard let url = Bundle.main.url(forResource: name, withExtension:"mp3") else { return }
      player = try! AVAudioPlayer(contentsOf: url)
      player.play()
   }
   
   @objc private func howToButtonTapped() {
      let alert = UIAlertController(title: "Как играть?", message: Help.text, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Понятно.", style: .default)
      alert.addAction(okAction)
      present(alert, animated: true)
   }
   
   //MARK: - Constraints
   
   private func setConstraints() {

      stepsLabel.snp.makeConstraints { make in
         make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
         make.left.equalToSuperview().inset(40)
      }
      stepsCountLabel.snp.makeConstraints { make in
         make.centerY.equalTo(stepsLabel)
         make.centerX.equalToSuperview()
      }
      stepsStepper.snp.makeConstraints { make in
         make.right.equalToSuperview().inset(40)
         make.centerY.equalTo(stepsLabel)
      }
      
      speedLabel.snp.makeConstraints { make in
         make.top.equalTo(stepsLabel.snp.bottom).inset(-30)
         make.left.equalToSuperview().inset(40)
      }
      speedCountLabel.snp.makeConstraints { make in
         make.centerY.equalTo(speedLabel)
         make.centerX.equalToSuperview()
      }
      speedStepper.snp.makeConstraints { make in
         make.right.equalToSuperview().inset(40)
         make.centerY.equalTo(speedLabel)
      }

      hideLabel.snp.makeConstraints { make in
         make.top.equalTo(speedLabel.snp.bottom).inset(-40)
         make.centerX.equalToSuperview()
      }
      hideSegmentControl.snp.makeConstraints { make in
         make.left.right.equalToSuperview().inset(40)
         make.top.equalTo(hideLabel.snp.bottom).inset(-10)
      }
      
      voiceLabel.snp.makeConstraints { make in
         make.top.equalTo(hideSegmentControl.snp.bottom).inset(-20)
         make.centerX.equalToSuperview()
      }

      menSegmentedControl.snp.makeConstraints { make in
         make.top.equalTo(voiceLabel.snp.bottom).inset(-10)
         make.left.right.equalToSuperview().inset(40)
      }
      
      womenSegmentedControl.snp.makeConstraints { make in
         make.top.equalTo(menSegmentedControl.snp.bottom).inset(-20)
         make.left.right.equalToSuperview().inset(40)
      }
   }
}
