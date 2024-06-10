//
//  EditTaskViewController.swift
//  test
//
//  Created by Admin on 09/06/24.
//

import Foundation


import UIKit
import Firebase
import SnapKit

class EditTaskViewController: UIViewController {

    var task: Task!
    var ref: DatabaseReference!

    // UI элементы для ввода новых параметров задачи
    var nameTextField: UITextField!
    var descriptionTextField: UITextField!
    var statusTextField: UITextField!
    var executorTextField: UITextField!
    var deadlineTextField: UITextField!
    var directorTextField: UITextField!
    
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить изменения", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(nil, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Изменить параметры задачи"
        view.backgroundColor = .white

        ref = Database.database().reference().child("tasks").child(task.id)

        setupViews()
        setupConstraints()
        displayTaskDetails()
    }

    func setupViews() {
        // Создание UI элементов для ввода новых параметров задачи
        nameTextField = UITextField()
        nameTextField.placeholder = "Название задачи"
        nameTextField.borderStyle = .roundedRect
        view.addSubview(nameTextField)

        descriptionTextField = UITextField()
        descriptionTextField.placeholder = "Описание задачи"
        descriptionTextField.borderStyle = .roundedRect
        view.addSubview(descriptionTextField)

        statusTextField = UITextField()
        statusTextField.placeholder = "Статус задачи"
        statusTextField.borderStyle = .roundedRect
        view.addSubview(statusTextField)

        executorTextField = UITextField()
        executorTextField.placeholder = "Исполнитель"
        executorTextField.borderStyle = .roundedRect
        view.addSubview(executorTextField)

        deadlineTextField = UITextField()
        deadlineTextField.placeholder = "Срок выполнения"
        deadlineTextField.borderStyle = .roundedRect
        view.addSubview(deadlineTextField)
        
        
        directorTextField = UITextField()
        directorTextField.placeholder = "Постановщик"
        directorTextField.borderStyle = .roundedRect
        view.addSubview(directorTextField)

    
        view.addSubview(saveButton)
    }

    func setupConstraints() {
        // Установка констрейнтов для UI элементов
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }

        descriptionTextField.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.left.right.equalTo(nameTextField)
        }

        statusTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(10)
            make.left.right.equalTo(descriptionTextField)
        }

        executorTextField.snp.makeConstraints { make in
            make.top.equalTo(statusTextField.snp.bottom).offset(10)
            make.left.right.equalTo(statusTextField)
        }

        deadlineTextField.snp.makeConstraints { make in
            make.top.equalTo(executorTextField.snp.bottom).offset(10)
            make.left.right.equalTo(executorTextField)
        }
        
        directorTextField.snp.makeConstraints { make in
            make.top.equalTo(deadlineTextField.snp.bottom).offset(10)
            make.left.right.equalTo(executorTextField)
        }
        

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(directorTextField.snp.bottom).offset(20)
            make.width.equalTo(180)
            make.height.equalTo(40)
            make.centerX.equalTo(view)
        }
        
    }

    func displayTaskDetails() {
        // Заполнение текстовых полей текущими параметрами задачи
        nameTextField.text = task.name
        descriptionTextField.text = task.description
        statusTextField.text = task.status
        executorTextField.text = task.executor
        deadlineTextField.text = task.deadline
        directorTextField.text = task.director
    }
    
    
    

    @objc func saveButtonTapped() {
        // Сохранение новых параметров задачи в базе данных
        guard let name = nameTextField.text,
              let description = descriptionTextField.text,
              let status = statusTextField.text,
              let executor = executorTextField.text,
              let deadline = deadlineTextField.text,
              let director = directorTextField.text else { return }

        let updatedTask = [
            "name": name,
            "description": description,
            "status": status,
            "executor": executor,
            "deadline": deadline,
            "director": director
        ]

        ref.updateChildValues(updatedTask) { error, _ in
            if let error = error {
                print("Error updating task: \(error.localizedDescription)")
                return
            }
            self.navigationController?.popViewController(animated: true)
        }
    
        self.dismiss(animated: true)
        
    }
}
