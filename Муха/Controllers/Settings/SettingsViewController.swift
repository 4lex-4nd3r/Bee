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
   
   // MARK: - Properties
   
   private var viewModel: SettingsViewModelProtocol!
   private var player: AVAudioPlayer!

   private let stepsLabel = UILabel(text: "шаги")
   private let stepsCountLabel = UILabel(size: 25, weight: .bold)
   private let speedLabel = UILabel(text: "время")
   private let speedCountLabel = UILabel(size: 25, weight: .bold)
   private lazy var stepsStepper = UIStepper(min: 5, max: 100, step: 5)
   private lazy var speedStepper = UIStepper(min: 1, max: 10, step: 0.5)
   private lazy var hideSegmentControl = UISegmentedControl(segments: ["Показать ячейки", "Спрятать ячейки"], color: .systemBlue)
   private lazy var menSegmentedControl = UISegmentedControl(segments: ["Даниил", "Дмитрий", "Филипп"], color: .systemBlue)
   private lazy var womenSegmentedControl = UISegmentedControl(segments: ["Анна", "Алена", "Карина"], color: .systemPink)
   
   private let reminderLabel = UILabel(text: "напоминание")
   
   private lazy var reminderSwitch: UISwitch = {
      let switcher = UISwitch()
      switcher.isOn = false
      switcher.onTintColor = .systemBlue
      return switcher
   }()
   
   private let datePicker: UIDatePicker = {
      let picker = UIDatePicker()
      picker.datePickerMode = .time
      picker.isEnabled = false
      picker.tintColor = .systemBlue
      return picker
   }()
   
   private var reminderStack = UIStackView()
   

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
      view.addSubview(hideSegmentControl)
      view.addSubview(menSegmentedControl)
      view.addSubview(womenSegmentedControl)
      reminderStack = UIStackView(arrangedSubviews: [reminderLabel,
                                                     datePicker,
                                                     reminderSwitch])
      reminderStack.axis = .horizontal
      reminderStack.distribution = .equalCentering
      view.addSubview(reminderStack)
   }
   
   private func setupTargets() {
      stepsStepper.addTarget(self, action: #selector(stepsStepperValueChanged), for: .valueChanged)
      speedStepper.addTarget(self, action: #selector(speedStepperValueChanged), for: .valueChanged)
      hideSegmentControl.addTarget(self, action: #selector(hideSegmentChanged), for: .valueChanged)
      womenSegmentedControl.addTarget(self, action: #selector(womenSegmentedChanged), for: .valueChanged)
      menSegmentedControl.addTarget(self, action: #selector(menSegmentedChanged), for: .valueChanged)
      reminderSwitch.addTarget(self, action: #selector(reminderSwitchChanged), for: .valueChanged)
      datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
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
      
      viewModel.timer.bind { [weak self] date in
         guard let self = self else { return }
         
         if let date = date {
            print("new value of timer is - \(date)")
            self.datePicker.setDate(date, animated: true)
            self.datePicker.isEnabled = true
            self.reminderSwitch.isOn = true
         } else {
            print("new value of timer is - nil")
            self.datePicker.isEnabled = false
            self.reminderSwitch.isOn = false
         }
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
   
   @objc private func reminderSwitchChanged() {
      if reminderSwitch.isOn {
         datePicker.isEnabled = true
         print(datePicker.date)
         viewModel.changeTimer(value: datePicker.date)
      } else {
         datePicker.isEnabled = false
         viewModel.changeTimer(value: nil)
      }
   }
   
   @objc private func datePickerChanged() {
      print(datePicker.date)
      viewModel.changeTimer(value: datePicker.date)
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
         make.top.equalTo(view.safeAreaLayoutGuide).inset(40)
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
         make.top.equalTo(stepsLabel.snp.bottom).inset(-20)
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
      hideSegmentControl.snp.makeConstraints { make in
         make.left.right.equalToSuperview().inset(40)
         make.top.equalTo(speedStepper.snp.bottom).inset(-40)
      }
      
      menSegmentedControl.snp.makeConstraints { make in
         make.top.equalTo(hideSegmentControl.snp.bottom).inset(-40)
         make.left.right.equalToSuperview().inset(40)
      }
      womenSegmentedControl.snp.makeConstraints { make in
         make.top.equalTo(menSegmentedControl.snp.bottom).inset(-5)
         make.left.right.equalToSuperview().inset(40)
      }
      
      reminderStack.snp.makeConstraints { make in
         make.left.right.equalToSuperview().inset(40)
         make.top.equalTo(womenSegmentedControl.snp.bottom).inset(-40)
      }
   }
}
