//
//  StatisticViewController.swift
//  Муха
//
//  Created by Александр on 28.07.2022.
//

import UIKit
import RealmSwift
import SnapKit

class StatisticViewController : UIViewController {
   
   //MARK: - Properties
   
   private var statistic: Results<StatisticModel>!
   private let localRealm = try! Realm()
   
   // MARK: - UI Properties
   
   private let tableView = UITableView()

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
      view.addSubview(tableView)
      tableView.frame = view.frame
      tableView.dataSource = self
      tableView.delegate = self
      tableView.rowHeight = 50
      tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: idStatisticCell)
      tableView.snp.makeConstraints { make in
         make.top.equalToSuperview().inset(40)
         make.left.right.bottom.equalToSuperview()
      }
   }
   
   //MARK: - Selectors

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
