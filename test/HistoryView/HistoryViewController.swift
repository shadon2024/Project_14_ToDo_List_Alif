//
//  HistoryViewController.swift
//  test
//
//  Created by Admin on 10/06/24.
//

import UIKit
import SnapKit
import Firebase




class HistoryViewController: UIViewController {

    var taskId: String?
    var historyEntries: [HistoryEntry] = []

    var ref: DatabaseReference!
    // UI элементы
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "History"
        view.backgroundColor = .white

        setupViews()
        setupConstraints()
        fetchHistoryEntries()
        ref = Database.database().reference().child("tasks").child(taskId ?? "nil").child("history")
    }

    func setupViews() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        view.addSubview(tableView)
    }

    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func fetchHistoryEntries() {
        
        let ref = Database.database().reference().child("tasks").child(taskId ?? "nil").child("history")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            var newEntries: [HistoryEntry] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot, let entry = HistoryEntry(snapshot: snapshot) {
                    newEntries.append(entry)
                }
            }
            self.historyEntries = newEntries.sorted(by: { $0.timestamp > $1.timestamp })
            self.tableView.reloadData()
        })
    }
    



}



extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyEntries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        let entry = historyEntries[indexPath.row]
        cell.textLabel?.text = "\(entry.timestamp): \(entry.description)"
        return cell
    }
}
