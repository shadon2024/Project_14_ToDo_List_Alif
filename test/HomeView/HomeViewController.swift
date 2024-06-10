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
    
    var tableView = UITableView() // Создаем экземпляр UITableView для отображения списка задач
    var tasks: [Task] = [] // Массив для хранения задач
    var ref: DatabaseReference! // Ссылка на базу данных Firebase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGreen // Устанавливаем цвет фона
        
        self.title = "Task" // Устанавливаем заголовок представления
        
        setupTableView() // Настройка таблицы
        setupViews() // Настройка интерфейса
        setupConstraints() // Установка ограничений
    }
    
    private func setupTableView() {
        
        ref = Database.database().reference().child("tasks") // Получаем ссылку на узел "tasks" в базе данных Firebase
        
        // Настройка обновления данных
        ref.observe(DataEventType.value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.tasks.removeAll() // Очищаем массив задач
                
                // Проходимся по всем данным в снимке
                for taskSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                    if let taskObject = taskSnapshot.value as? [String: AnyObject] {
                        let taskName = taskObject["name"]
                        let taskDescription = taskObject["description"]
                        let taskStatus = taskObject["status"]
                        let taskExecutor = taskObject["executor"]
                        let taskDeadline = taskObject["deadline"]
                        let taskDirector = taskObject["director"]
                        
                        // Создаем объект задачи из данных снимка и добавляем его в массив задач
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
                
                self.tableView.reloadData() // Обновляем таблицу
            }
        })
        
    }
    
    func setupViews() {
        tableView = UITableView() // Создаем экземпляр UITableView
        tableView.delegate = self // Назначаем делегат таблицы
        tableView.dataSource = self // Назначаем источник данных таблицы
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: "TaskCell") // Регистрируем ячейку для таблицы
        view.addSubview(tableView) // Добавляем таблицу на представление
        
        // Создаем кнопку добавления задачи в панели навигации
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskButtonTapped))
        navigationItem.rightBarButtonItem = addButton // Устанавливаем кнопку в правой части навигационной панели
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // Устанавливаем ограничения таблицы, чтобы она занимала всю доступную область
        }
    }
    
    // Обработчик нажатия на кнопку добавления задачи
    @objc func addTaskButtonTapped() {
        // Реализация добавления новой задачи
        
        let alertController = UIAlertController(title: "Добавить задачу", message: nil, preferredStyle: .alert) // Создаем контроллер предупреждения
        
        // Добавляем текстовые поля для ввода данных о задаче
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
        
        // Добавляем кнопку "Добавить"
        let addAction = UIAlertAction(title: "Добавить", style: .default) { (_) in
            guard let taskName = alertController.textFields?[0].text,
                  let taskDescription = alertController.textFields?[1].text,
                  let taskStatus = alertController.textFields?[2].text,
                  let taskExecutor = alertController.textFields?[3].text,
                  let taskDeadline = alertController.textFields?[4].text,
                  let taskDirector = alertController.textFields?[5].text else { return }
            
            // Создаем словарь с данными о задаче и добавляем его в базу данных Firebase
            let task = ["name": taskName,
                        "description": taskDescription,
                        "status": taskStatus,
                        "executor": taskExecutor,
                        "deadline": taskDeadline,
                        "director": taskDirector]
            
            self.ref.childByAutoId().setValue(task)
            
        }
        
        // Добавляем кнопку "Отмена"
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alertController.addAction(addAction) // Добавляем кнопку "Добавить" в контроллер предупреждения
        alertController.addAction(cancelAction) // Добавляем кнопку "Отмена" в контроллер предупреждения
        
        present(alertController, animated: true, completion: nil) // Отображаем контроллер предупреждения
    }
    
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Устанавливаем количество строк в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    // Устанавливаем содержимое ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! HomeTableViewCell
        let task = tasks[indexPath.row]

        // Устанавливаем значения ячейки из задачи
        cell.setCellWithValuesOf(task)
        return cell
    }

    // Реализация удаления задачи
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            ref.child(task.id).removeValue() // Удаляем задачу из базы данных Firebase
        }
    }

    // Устанавливаем высоту ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    // Обработка выбора ячейки
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        // Переходим к экрану с деталями задачи
        let taskDetailVC = TaskDetailViewController()
        taskDetailVC.task = tasks[indexPath.row] // Передаем выбранную задачу на экран с деталями
        navigationController?.pushViewController(taskDetailVC, animated: true)
    }
}

// Протокол для обновления задачи
protocol TaskUpdateDelegate: AnyObject {
    func updateTask(_ task: Task)
}

// Расширение для обработки обновления задачи
extension HomeViewController: TaskUpdateDelegate {
    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task // Если задача уже существует в массиве, обновляем ее
        } else {
            tasks.append(task) // Иначе добавляем новую задачу в массив
        }
        tableView.reloadData() // Обновляем таблицу
    }
}
