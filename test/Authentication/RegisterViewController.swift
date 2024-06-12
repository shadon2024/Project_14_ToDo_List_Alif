//
//  RegisterViewController.swift
//  Task_List_Alif
//
//  Created by Admin on 07/06/24.
//

import UIKit
import SnapKit
import FirebaseAuth
import Firebase

class RegisterViewController: UIViewController {

    var userList: [ListUser] = [] // Массив для хранения user
    var ref: DatabaseReference! // Ссылка на базу данных Firebase
    
    lazy var iconImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "a.circle.fill")
        return image
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        //indicator.center = view.center
        indicator.hidesWhenStopped = true
        return indicator
    }()

    

    
    
    lazy var userEmailTextField: UITextField = {
        var textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        textField.font = .systemFont(ofSize: 18, weight: .regular)
        textField.borderStyle = .roundedRect
        textField.textContentType = .emailAddress
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        return textField
    }()
    
    
    

    
    
    lazy var userNameTextField: UITextField = {
        var textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 8
        textField.font = .systemFont(ofSize: 18, weight: .regular)
        textField.borderStyle = .roundedRect
        textField.textContentType = .username
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        return textField
    }()
    
    

    
    lazy var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 18, weight: .regular)
        textField.layer.cornerRadius = 8
        //textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        //textField.textContentType = nil
        textField.autocorrectionType = .no
        textField.textContentType = .newPassword // Используем newPassword для создания новых учетных записей
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        return textField
    }()
 


    
    lazy var passwordRepeatTextField: UITextField = {
        var textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.masksToBounds = true
        textField.font = .systemFont(ofSize: 18, weight: .regular)
        textField.layer.cornerRadius = 8
        //textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        //textField.textContentType = nil
        textField.autocorrectionType = .no
        textField.textContentType = .newPassword // Используем newPassword для создания новых учетных записей
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        return textField
    }()
    
    
    
    
    let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Зарегистрироваться", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(nil, action: #selector(createAccountetButtonTaped), for: .touchUpInside)
        button.layer.cornerRadius = 11
        return button
    }()
    

    
    @objc func createAccountetButtonTaped() {
        
        
        guard let email = userEmailTextField.text, !email.isEmpty,
              let username = userNameTextField.text, !username.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let passwordRepeat = passwordRepeatTextField.text, !passwordRepeat.isEmpty else {
            // Показать ошибку, что все поля должны быть заполнены
            showError("All fields are required")
            return
        }

        guard password == passwordRepeat else {
            // Показать ошибку, что пароли не совпадают
            showError("Passwords do not match")
            return
        }
        
        activityIndicator.startAnimating()
        
        // Создание пользователя через Firebase
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            self.activityIndicator.stopAnimating()
            if let error = error {
                // Показать ошибку регистрации
                self.showError("Registration failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else {
                self.showError("Failed to get user information")
                return
            }

            // Обновление профиля пользователя
            //let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges { error in
                if let error = error {
                    // Показать ошибку обновления профиля
                    self.showError("Profile update failed: \(error.localizedDescription)")
                    return
                }

                // Перейти к следующему экрану или показать сообщение об успешной регистрации
                self.showSuccess("Account created successfully")
                
                
//                DispatchQueue.main.async {
//                    self.registerUser()
//                    self.navigateToHomeViewController()
//
//
//
//                }
                // Сохранение данных пользователя в Realtime Database
                self.saveUserToDatabase(user: user, email: email, username: username)
            }
        }
        
    }
    
    
    
    private func saveUserToDatabase(user: User, email: String, username: String) {
        let ref = Database.database().reference()
        let listUser = ListUser(id: user.uid, email: email, name: username)
        ref.child("users").child(user.uid).setValue(listUser.toDictionary()) { error, _ in
            if let error = error {
                self.showError("Failed to save user data: \(error.localizedDescription)")
            } else {
                // Перейти к следующему экрану или показать сообщение об успешной регистрации
                self.showSuccess("Account created successfully")
                
                DispatchQueue.main.async {
                    self.registerUser()
                    self.navigateToHomeViewController()
                }
            }
        }
    }
    
    
    
    func registerUser() {


        // Если регистрация прошла успешно
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.userRegistered()
    }
    
    private func navigateToHomeViewController() {
        let home = HomeViewController()
        home.navigationItem.hidesBackButton = true
        navigationController?.pushViewController(home, animated: true)
    }
    
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    func showSuccess(_ message: String) {
        let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }




    
   

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        
        setupViews()
        setupConstraints()
        setupConfigure()
        
        // Устанавливаем делегаты текстовых полей
        userEmailTextField.delegate = self
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        passwordRepeatTextField.delegate = self
        
        textFieldDidBeginEditing(userEmailTextField)
        textFieldDidBeginEditing(userNameTextField)
        textFieldDidBeginEditing(passwordTextField)
        textFieldDidBeginEditing(passwordRepeatTextField)
 
        
    }
    
    
    
    private func setupViews() {
        view.addSubview(userEmailTextField)
        userEmailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(createAccountButton)
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        

        view.addSubview(iconImage)
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(userNameTextField)
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        view.addSubview(passwordRepeatTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
    private func setupConstraints() {
        
        
        iconImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(0)
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        
        
        userEmailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.width.equalTo(350)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        

        
        userNameTextField.snp.makeConstraints { make in
            make.top.equalTo(userEmailTextField.snp.bottom).offset(25)
            make.width.equalTo(350)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        
        
        
        
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(userNameTextField.snp.bottom).offset(25)
            make.width.equalTo(350)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        
        

        passwordRepeatTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(25)
            make.width.equalTo(350)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(passwordRepeatTextField.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        
        createAccountButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(150)
            make.width.equalTo(350)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        

        

        
    }
    
    
    private func setupConfigure() {
        // атрибут с нужным вам цветом текста
        let placeholderColor = UIColor.gray // Любой цвет, который вы хотите использовать

        // атрибут для плейсхолдера с выбранным цветом текста
        let attributes = [
            NSAttributedString.Key.foregroundColor: placeholderColor
        ]
        
        // атрибуты для плейсхолдера
        userEmailTextField.attributedPlaceholder = NSAttributedString(string: "Ваш email", attributes: attributes)
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "Ваше имя", attributes: attributes)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Ваш пароль", attributes: attributes)
        passwordRepeatTextField.attributedPlaceholder = NSAttributedString(string: "Подтверждение пароля", attributes: attributes)
        
        
        

        
        
        // Добавление обработчика жеста для скрытия клавиатуры
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    

    



}



extension RegisterViewController: UITextFieldDelegate {
    
    // Метод делегата UITextFieldDelegate, вызываемый при начале редактирования текстового поля
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder() // Показываем клавиатуру
    }
    
    // Метод для скрытия клавиатуры при касании вне текстовых полей
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    // Метод делегата UITextFieldDelegate, вызываемый перед изменением текста в поле
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == userEmailTextField || textField == userNameTextField || textField == passwordTextField || textField == passwordRepeatTextField{
            // Проверяем, не превышает ли количество символов 26
            let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            return newText!.count <= 26
        }
        return true
    }
}




/*
 
 
 ref = Database.database().reference().child("userList") // Получаем ссылку на узел "tasks" в базе данных Firebase
 
 // Настройка обновления данных
 ref.observe(DataEventType.value, with: { (snapshot) in
     if snapshot.childrenCount > 0 {
     self.userList.removeAll() // Очищаем массив задач
         
         // Проходимся по всем данным в снимке
     for taskSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
     if let taskObject = taskSnapshot.value as? [String: AnyObject] {
         let listEmail = taskObject["email"]
         let listName = taskObject["name"]
 
                 // Создаем объект задачи из данных снимка и добавляем его в массив задач
         let task = ListUser(id: taskSnapshot.key,
                             email: listEmail as? String ?? "",
                             name: listName as? String ?? "")
             self.userList.append(task)
             }
         }
         
         
     let taski = ["email": email,
                 "name": username,
         
     self.ref.childByAutoId().setValue(taski)
         
     }
 })
 
 */
