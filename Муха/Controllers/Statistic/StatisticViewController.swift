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
   
   private let tableView = UITableView(frame: .infinite, style: .plain)
   
   private lazy var deleteButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .done, target: self, action: #selector(deleteButtonTapped))

   let statisticCell = StatisticTableViewCell()
   let idStatisticCell = "idStatisticCell"
   
   // MARK: - Lifecycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      setupViews()
      getStatistics()
   }

   //MARK: - Setups
   
   private func setupViews() {
      view.backgroundColor = .systemBackground
      navigationItem.title = "Cтатистика"
      navigationItem.rightBarButtonItem = deleteButton
      view.addSubview(tableView)
      tableView.frame = view.frame
      tableView.dataSource = self
      tableView.delegate = self
      tableView.rowHeight = 50
      tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: idStatisticCell)
   }
   
   //MARK: - Selectors

   @objc private func deleteButtonTapped() {
      
      let alert = UIAlertController(title: "Удалить историю игр?", message: "Внимание! Удаление необратимо. Вы уверены?", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Да, удалить", style: .destructive) { action in
         StatisticManager.shared.deleteAllResults()
         self.tableView.reloadData()
         self.navigationItem.rightBarButtonItem = nil
      }
      let cancelAction = UIAlertAction(title: "Не удалять", style: .default)
      alert.addAction(okAction)
      alert.addAction(cancelAction)
      present(alert, animated: true)
   }
   
   private func getStatistics() {
      statistic = localRealm.objects(StatisticModel.self).sorted(byKeyPath: "date", ascending: false)
      print(statistic.count)
      if statistic.isEmpty {
         navigationItem.rightBarButtonItem = nil
      }
      tableView.reloadData()
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
