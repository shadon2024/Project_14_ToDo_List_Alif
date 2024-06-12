//
//  UsersViewController.swift
//  test
//
//  Created by Admin on 10/06/24.
//

import UIKit
import SnapKit
import Firebase

class UsersViewController: UIViewController {
    
    
    var tableView = UITableView()
    
    // Массив для хранения данных о пользователях
    var users: [ListUser] = []
    var ref: DatabaseReference! // Ссылка на базу данных Firebase
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
        
        
        setupViews()
        fetchUsers()
    }
    
    
    private func setupViews() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    // Получение данных о пользователях из Firebase
    private func fetchUsers() {
        
        ref = Database.database().reference().child("users")
            ref.observe(.value, with: { snapshot in
                //print("Snapshot: \(snapshot)") // Для отладки
                var newUsers: [ListUser] = []
                for child in snapshot.children {
                    if let snapshot = child as? DataSnapshot, let user = ListUser(snapshot: snapshot) {
                        newUsers.append(user)
                    }
                }
                self.users = newUsers
                self.tableView.reloadData()
                //print("Users: \(self.users)") // Для отладки
            }) { error in
                //print("Failed to fetch users: \(error.localizedDescription)")
            }
    }
    
}
    
    
    
    
    




extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentTableViewCell
        
        let comment = users[indexPath.row]
        
        cell.configure(with: comment)
        //cell.textLabel?.text = comment.name
        //cell.detailTextLabel?.text = comment.email
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableView.automaticDimension
        return 60
    }
    
}
