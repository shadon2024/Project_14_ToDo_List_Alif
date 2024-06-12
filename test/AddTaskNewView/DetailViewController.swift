//
//  DetailViewController.swift
//  test
//
//  Created by Admin on 11/06/24.
//

import UIKit
import FirebaseAuth
import Firebase

class DetailViewController: UIViewController   {
    
    var tableView = UITableView() // Создаем экземпляр UITableView для отображения списка задач
    var tasks: [Task] = [] // Массив для хранения задач
    var ref: DatabaseReference! // Ссылка на базу данных Firebase
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()
        setupDeadlineTextField()
        fetchUsers()
        
        
    }
    
    
    
    // Ленивое создание метки с названием задачи
    lazy var nameLabel: UITextField = {
        let label = UITextField()
        label.placeholder = " Название"
        label.backgroundColor = .systemGray6
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    
    // Ленивое создание метки с описанием задачи
    lazy var descriptionLabel: UITextField = {
        let label = UITextField()
        label.placeholder = " Описание"
        label.backgroundColor = .systemGray6
        return label
    }()
    
    
    // Ленивое создание метки со статусом задачи
    lazy var status: UITextField = {
        let label = UITextField()
        label.placeholder = " Статус"
        label.text = "В работе Ожидание Закрыта"
        label.backgroundColor = .systemGray6
        return label
    }()
    
    
    
    
    // Ленивое создание метки с сроком выполнения задачи
    let datePicker = UIDatePicker()
    lazy var deadline: UITextField = {
        let label = UITextField()
        label.placeholder = " Срок выполнения"
        label.backgroundColor = .systemGray6
        
        return label
    }()
    
    func setupDeadlineTextField() {
        
        let screenWidth = UIScreen.main.bounds.height
        datePicker.frame = CGRect(x: 0, y: 0, width: Int(screenWidth), height: 300)
        datePicker.datePickerMode = .date
        deadline.inputView = datePicker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: nil, action: #selector(cancelButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: nil, action: #selector(doneButtonTapped))
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        deadline.inputAccessoryView = toolbar
        
        datePicker.datePickerMode = .dateAndTime // Выбор даты и времени
        datePicker.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        datePicker.locale = Locale(identifier: "ru_RU") // Установите locale для отображения
        datePicker.preferredDatePickerStyle = .compact
        datePicker.translatesAutoresizingMaskIntoConstraints = false // Enable Auto Layout
        
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm" // Формат даты и времени
        deadline.text = dateFormatter.string(from: sender.date)
    }
    
    @objc func handleTap() {
        deadline.resignFirstResponder() // Скрыть клавиатуру
    }
    
    
    @objc func doneButtonTapped() {
        // Скрываем клавиатуру (закрываем UIDatePicker)
        deadline.resignFirstResponder()
    }
    
    @objc func cancelButtonTapped() {
        // Очищаем текстовое поле
        deadline.text = ""
        // Скрываем клавиатуру (закрываем UIDatePicker)
        deadline.resignFirstResponder()
    }
    
    
    
    
    
    // Ленивое создание метки с исполнителем задачи
    //let statusOptions = ["В работе", "Ожидание", "Закрыта"]
    var users: [ListUser] = []
    //var ref: DatabaseReference!
    
    let pickerView = UIPickerView()
    lazy var executor: UITextField = {
        let label = UITextField()
        label.placeholder = " Испольнитель"
        //label.text = users[row].name
        label.borderStyle = .roundedRect
        label.backgroundColor = .systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.inputView = pickerView
        view.addSubview(label)
        return label
    }()
    
    
    private func fetchUsers() {
  
        let ref = Database.database().reference().child("users")
                
                ref.observe(.value, with: { snapshot in
                    self.users.removeAll()
                    
                    for child in snapshot.children {
                        if let snap = child as? DataSnapshot,
                           let user = ListUser(snapshot: snap) { // Создаем объект ListUser из словаря
                            self.users.append(user)
                        }
                    }
                    
                    self.pickerView.reloadAllComponents()
                }) { error in
                    print("Error fetching users: \(error.localizedDescription)")
                }
    
    }
    
    
    
    
    // Ленивое создание метки с постановщиком задачи
    lazy var director: UITextField = {
        let label = UITextField()
        label.placeholder = "Постановщик"
        label.text = "@\(Auth.auth().currentUser?.displayName ?? "nil")"
        label.backgroundColor = .systemGray6
        return label
    }()
    
    
    let addTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(nil, action: #selector(addTaskButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    @objc func addTaskButtonTapped() {
        
        // Получаем ссылку на базу данных
        let ref = Database.database().reference()
        
        // Создаем словарь с данными о задаче и добавляем его в базу данных Firebase
        let task: [String: String] = [
            "name": nameLabel.text ?? "",
            "description": descriptionLabel.text ?? "",
            "status": status.text ?? "",
            "executor": executor.text ?? "",
            "deadline": deadline.text ?? "",
            "director": director.text ?? ""]
        
        
        // Сохраняем данные в базу данных под уникальным ключом
                ref.child("tasks").childByAutoId().setValue(task) { error, _ in
                    if let error = error {
                        print("Error saving data: \(error.localizedDescription)")
                    } else {
                        print("Data saved successfully!")
                        self.dismiss(animated: true, completion: nil)
                    }
                }
    }
    
    
    let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Закрыть", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(nil, action: #selector(cancellButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    
    @objc func cancellButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    private func setupViews() {
        view.backgroundColor = .white
        self.title = "Добавить задачу"
        
        pickerView.delegate = self
        pickerView.dataSource = self
        deadline.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        executor.delegate = self
        
        
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(status)
        status.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(deadline)
        deadline.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(executor)
        executor.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(director)
        director.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addTaskButton)
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(45)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(40)
        }
        
        status.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(40)
        }
        
        deadline.snp.makeConstraints { make in
            make.top.equalTo(status.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(40)
        }
        
        executor.snp.makeConstraints { make in
            make.top.equalTo(deadline.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(40)
        }
        
        director.snp.makeConstraints { make in
            make.top.equalTo(executor.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(320)
            make.height.equalTo(40)
        }
        
        addTaskButton.snp.makeConstraints { make in
            make.top.equalTo(executor.snp.bottom).offset(20)
            //make.centerX.equalToSuperview()
            make.left.equalTo(director)
            make.width.equalTo(140)
            make.height.equalTo(40)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(executor.snp.bottom).offset(20)
            //make.centerX.equalToSuperview()
            make.right.equalTo(director)
            make.width.equalTo(140)
            make.height.equalTo(40)
        }
        
    }
    
    
}
    
    

extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Один столбец в UIPickerView
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return users.count    // Количество опций статуса
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        executor.text = "\(users[row].name)" // Установить выбранное значение статуса в текстовое поле
        executor.resignFirstResponder() // Закрываем UIPickerView после выбора значения
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return users[row].name // Убедитесь, что возвращается правильная строка для каждой строки
    }
}




extension DetailViewController: UITextFieldDelegate {
    
}
