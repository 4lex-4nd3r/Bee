//
//  StatisticViewController.swift
//  Муха
//
//  Created by Александр on 28.07.2022.
//

import UIKit
import RealmSwift

class StatisticViewController : UIViewController {
   
   //MARK: - Properties
   
   private var statistic: Results<StatisticModel>!
   private let localRealm = try! Realm()
   
   // MARK: - UI Properties
      
   private let statLabel: UILabel = {
      let label = UILabel()
      label.font = .systemFont(ofSize: 25)
      label.text = "История"
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
   }()
   
   private let tableView: UITableView = {
      let tableView = UITableView(frame: .zero, style: .plain)
      tableView.translatesAutoresizingMaskIntoConstraints = false
      return tableView
   }()
   
   private lazy var deleteButton: UIButton = {
      let button = UIButton()
      button.isHidden = true
      button.setBackgroundImage(UIImage(systemName: "trash"), for: .normal)
      button.layer.cornerRadius = 10
      button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
   }()
   
   private lazy var backButton: UIButton = {
      let button = UIButton()
      button.setTitle("Назад", for: .normal)
      button.backgroundColor = .systemBlue
      button.layer.cornerRadius = 10
      button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
   }()
   
   let statisticCell = StatisticTableViewCell()
   let idStatisticCell = "idStatisticCell"
   
   // MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      setConstraints()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      getStatistics()
   }
   
   //MARK: - Setups
   
   private func setupViews() {
      view.backgroundColor = .systemBackground
      view.addSubview(statLabel)
      view.addSubview(tableView)
      tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: idStatisticCell)
      tableView.rowHeight = 50
      tableView.delegate = self
      tableView.dataSource = self
      view.addSubview(backButton)
      view.addSubview(deleteButton)
   }
   
   //MARK: - Selectors
   
   @objc private func backButtonTapped() {
      dismiss(animated: true)
   }
   
   @objc private func deleteButtonTapped() {
      
      let alert = UIAlertController(title: "Удалить историю игр?", message: "Внимание! Удаление необратимо. Вы уверены?", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Да, удалить", style: .destructive) { action in
         StatisticManager.shared.deleteAllResults()
         self.tableView.reloadData()
         self.deleteButton.isHidden = true
      }
      let cancelAction = UIAlertAction(title: "Не удалять", style: .default)
      alert.addAction(okAction)
      alert.addAction(cancelAction)
      present(alert, animated: true)
   }
   
   private func getStatistics() {
      
      
      statistic = localRealm.objects(StatisticModel.self).sorted(byKeyPath: "date", ascending: false)
      

      if !statistic.isEmpty {
         deleteButton.isHidden = false
      }
      tableView.reloadData()
   }
   
   //MARK: - Constraints
   
   private func setConstraints() {
      
      NSLayoutConstraint.activate([
         statLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         statLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
      ])
      
      NSLayoutConstraint.activate([
         tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         tableView.topAnchor.constraint(equalTo: statLabel.bottomAnchor, constant: 20),
         tableView.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -40)
      ])
      
      NSLayoutConstraint.activate([
         backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         backButton.widthAnchor.constraint(equalToConstant: 150),
         backButton.heightAnchor.constraint(equalToConstant: 50),
         backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
      ])
      
      NSLayoutConstraint.activate([
         deleteButton.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
         deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
         deleteButton.widthAnchor.constraint(equalToConstant: 30),
         deleteButton.heightAnchor.constraint(equalToConstant: 30)
      ])
   }
}

extension StatisticViewController: UITableViewDelegate, UITableViewDataSource {

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      statistic.count
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: idStatisticCell, for: indexPath) as? StatisticTableViewCell else { return UITableViewCell() }
      
      let statisticModel = statistic[indexPath.row]
      cell.configure(statisticModel: statisticModel)
      return cell
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      60
   }
}
