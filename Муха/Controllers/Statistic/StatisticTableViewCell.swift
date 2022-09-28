//
//  StatisticTableViewCell.swift
//  Муха
//
//  Created by Александр on 28.07.2022.
//

import UIKit

class StatisticTableViewCell: UITableViewCell {
   
   // MARK: - Properties
   
   private let winImageView: UIImageView = {
      let imageView = UIImageView()
      imageView.image = UIImage(systemName: "person")
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
   }()
   
   private let dateLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 14)
      label.numberOfLines = 0
      label.textAlignment = .center
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   
   private let isHideLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 14)
      label.textAlignment = .center
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   
   private let stepsLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 14)
      label.textAlignment = .center
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   private let speedLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 14)
      label.textAlignment = .center
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()

   //MARK: - Init
   
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      setupViews()
      setConstraints()
      selectionStyle = .none
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   // MARK: - Setups
   
   private func setupViews() {
      backgroundColor = .clear
      addSubview(winImageView)
      addSubview(dateLabel)
      addSubview(isHideLabel)
      addSubview(stepsLabel)
      addSubview(speedLabel)
   }
   
   func configure(statisticModel: StatisticModel) {
      let formatter = DateFormatter()
      formatter.dateFormat = "dd.MM.yy"
      
      let winImage = UIImage(systemName: "checkmark")
      let lossImage = UIImage(systemName: "xmark")
      
      winImageView.image = statisticModel.isWin ? winImage : lossImage
      winImageView.tintColor = statisticModel.isWin ? .systemBlue : .systemRed
      dateLabel.text = S.StatisticCell.date + formatter.string(from: statisticModel.date)
      stepsLabel.text = S.StatisticCell.steps + "\(statisticModel.steps)"
      speedLabel.text = S.StatisticCell.speed + "\(round(statisticModel.speed * 10) / 10.0)"
      isHideLabel.text = statisticModel.isHide ? S.StatisticCell.isHideYes : S.StatisticCell.isHideNo
   }
   
   
   //MARK: - Constraints
   
   private func setConstraints() {
      
      NSLayoutConstraint.activate([
         winImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
         winImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
         winImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
         winImageView.heightAnchor.constraint(equalToConstant: 30),
         winImageView.widthAnchor.constraint(equalToConstant: 30)
      ])
      
      NSLayoutConstraint.activate([
         dateLabel.leadingAnchor.constraint(equalTo: winImageView.trailingAnchor, constant: 30),
         dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10)
      ])
      
      NSLayoutConstraint.activate([
         isHideLabel.leadingAnchor.constraint(equalTo: winImageView.trailingAnchor, constant: 30),
         isHideLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
      ])

      NSLayoutConstraint.activate([
         stepsLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 30),
         stepsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      ])
      
      NSLayoutConstraint.activate([
         speedLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 30),
         speedLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
      ])
   }
}
