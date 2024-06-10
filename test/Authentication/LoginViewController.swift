//
//  ViewController.swift
//  Task_List_Alif
//
//  Created by Admin on 06/06/24.
//

import UIKit
import SnapKit
import FirebaseAuth

class LoginViewController: UIViewController {

    
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .large
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    
    
    lazy var stackView: UIStackView = {
        var stack = UIStackView()
        stack.backgroundColor = .darkGray
        stack.layer.cornerRadius = 20
        return stack
    }()
    
    lazy var iconImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "a.circle.fill")
        return image
    }()
    
    

    
    lazy var textHeader: UILabel = {
        var text = UILabel()
        text.text = "Алиф"
        text.textAlignment = .center
        text.textColor = .white
        text.font = .systemFont(ofSize: 20, weight: .semibold)
        return text
    }()
    

    
    lazy var userNameTextField: UITextField = {
        var textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 13
        textField.font = .systemFont(ofSize: 18, weight: .regular)
        textField.borderStyle = .roundedRect
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
        textField.layer.cornerRadius = 13
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        return textField
    }()
    
    
    
    
    
 

    
    let signButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Войти", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(nil, action: #selector(loginButtonTaped), for: .touchUpInside)
        button.layer.cornerRadius = 15
        return button
    }()
    
    @objc func loginButtonTaped() {
        
        guard let email = userNameTextField.text, !email.isEmpty,
                      let password = passwordTextField.text, !password.isEmpty else {
                    // Показать ошибку, что все поля должны быть заполнены
                    showError("All fields are required")
                    return
                }
        
                activityIndicator.startAnimating()
                
                // Вход через Firebase
                Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    self.activityIndicator.stopAnimating()
                    if let error = error {
                        // Показать ошибку входа
                        self.showError("Login failed: \(error.localizedDescription)")
                        return
                    }

                    // Перейти к следующему экрану или показать сообщение об успешном входе
                    self.showSuccess("Login successful")
                    
                    DispatchQueue.main.async {
                        self.authenticateUser()
                        self.navigateToHomeViewController()
                        
                        


                        
                    }
                    
                    
                    
                }
        
    }
    
    
    func authenticateUser() {
        // Код для аутентификации пользователя
        
        // Если аутентификация прошла успешно
        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        sceneDelegate?.userLoggedIn()
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

    
    
    
    
    
    let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Создать новый аккаунт", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(nil, action: #selector(registButtonTaped), for: .touchUpInside)
        button.layer.cornerRadius = 15
        return button
    }()
    @objc func registButtonTaped() {
        let vc =  RegisterViewController()
        navigationController?.pushViewController(vc, animated: true)
        //present(vc, animated: true)
    }
    
    
    //let showHideButton = UIButton(type: .custom)
    var isPasswordHidden = true // Состояние отображения пароля
    let imageShowBatton = UIImage(systemName: "eye.slash")
    
    
    lazy var  showHideButton: UIButton = {   // кнопка , которая будет переключать видимость пароля
        let button = UIButton(type: .system)
        button.setImage(imageShowBatton, for: .normal)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.frame = CGRect(x: CGFloat(passwordTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(showHideButtonTapped), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 10)
        return button
    }()
    
    // Делегирование кнопки переключения видимости пароля
    @objc func showHideButtonTapped(sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle() // Переключает видимость текста между скрытым и отображаемым
        isPasswordHidden.toggle() // Инвертирует состояние отображения пароля
        updateShowHideButtonImage() // Обновляет изображение кнопки
    }
    
    // Функция для обновления изображения кнопки в зависимости от состояния отображения пароля
    func updateShowHideButtonImage() {
        let imageName = isPasswordHidden ? "eye.slash" : "eye" // Имя изображения в зависимости от состояния отображения пароля
        showHideButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        
        
        setupViews()
        setupConstraints()
        setupConfigure()
        
        // Устанавливаем делегаты текстовых полей
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
        textFieldDidBeginEditing(userNameTextField)
        textFieldDidBeginEditing(passwordTextField)
    }
    
    private func setupViews() {
        stackView.addSubview(userNameTextField)
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addSubview(signButton)
        signButton.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addSubview(textHeader)
        textHeader.translatesAutoresizingMaskIntoConstraints = false
        
        
        stackView.addSubview(createAccountButton)
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(iconImage)
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

    }
    
    
    private func setupConstraints() {
        
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(180)
            make.leading.equalTo(0)
            make.trailing.equalTo(0)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
        
        iconImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(80)
            //make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
            //make.centerY.equalToSuperview()
        }
        
        
        textHeader.snp.makeConstraints { make in
            make.top.equalTo(iconImage.snp.bottom).offset(460)
            make.width.equalTo(300)
            make.centerX.equalToSuperview()
        }
        
        userNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(240)
            make.width.equalTo(350)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(userNameTextField.snp.bottom).offset(20)
            make.width.equalTo(350)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        signButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.width.equalTo(350)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
        }
        
        
        createAccountButton.snp.makeConstraints { make in
            make.top.equalTo(signButton.snp.bottom).offset(60)
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
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "Имя или эл. адрес", attributes: attributes)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Пароль", attributes: attributes)
        
        

        // кнопка к текстовому полю
        passwordTextField.rightView = showHideButton
        passwordTextField.rightViewMode = .always
        
        
        // Добавление обработчика жеста для скрытия клавиатуры
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    

    



}



extension LoginViewController: UITextFieldDelegate {
    
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
        if textField == userNameTextField || textField == passwordTextField {
            // Проверяем, не превышает ли количество символов 26
            let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
            return newText!.count <= 26
        }
        return true
    }
}




