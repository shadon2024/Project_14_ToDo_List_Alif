//
//  HomeViewController.swift
//  test
//
//  Created by Admin on 08/06/24.
//

import UIKit
import FirebaseAuth
import Firebase

class HomeViewController: UIViewController {

    var tableView = UITableView()
    var tasks: [Task] = []
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemGreen
        
        self.title = "Task"
        
        setupTableView()
        setupViews()
        setupConstraints()
    }
    
    
    
    
    private func setupTableView() {
        
        ref = Database.database().reference().child("tasks")

        // Настройка обновления данных
        ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.tasks.removeAll()

                for taskSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                    if let taskObject = taskSnapshot.value as? [String: AnyObject] {
                        let taskName = taskObject["name"]
                        let taskDescription = taskObject["description"]
                        let taskStatus = taskObject["status"]
                        let taskExecutor = taskObject["executor"]
                        let taskDeadline = taskObject["deadline"]
                        let taskDirector = taskObject["director"]

                        let task = Task(id: taskSnapshot.key,
                                        name: taskName as? String ?? "",
                                        description: taskDescription as? String ?? "",
                                        status: taskStatus as? String ?? "",
                                        executor: taskExecutor as? String ?? "",
                                        deadline: taskDeadline as? String ?? "",
                                        director: taskDirector as? String ?? "")
                        self.tasks.append(task)
                    }
                }

                self.tableView.reloadData()
            }
        })
        
    }

    
    func setupViews() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "TaskCell")
        view.addSubview(tableView)

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    
    @objc func addTaskButtonTapped() {
        // Реализация добавления новой задачи
        
        let alertController = UIAlertController(title: "Добавить задачу", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Название"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Описание"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Статус"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Исполнитель"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Срок выполнения"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Постановщик"
        }
        
        let addAction = UIAlertAction(title: "Добавить", style: .default) { (_) in
            guard let taskName = alertController.textFields?[0].text,
                  let taskDescription = alertController.textFields?[1].text,
                  let taskStatus = alertController.textFields?[2].text,
                  let taskExecutor = alertController.textFields?[3].text,
                  let taskDeadline = alertController.textFields?[4].text,
                  let taskDirector = alertController.textFields?[4].text else { return }
            
            let task = ["name": taskName,
                        "description": taskDescription,
                        "status": taskStatus,
                        "executor": taskExecutor,
                        "deadline": taskDeadline,
                        "director": taskDirector]
            
            self.ref.childByAutoId().setValue(task)
            
        }
        
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alertController.addAction(addAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
    
    


}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! HomeTableViewCell
        let task = tasks[indexPath.row]

        //cell.textLabel?.text = task.name
        //cell.textLabel?.text = task.status

        cell.setCellWithValuesOf(task)
        return cell
    }

    // Реализация удаления задачи
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            ref.child(task.id).removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let taskDetailVC = TaskDetailViewController()
        taskDetailVC.task = tasks[indexPath.row]
        navigationController?.pushViewController(taskDetailVC, animated: true)

    }
}
