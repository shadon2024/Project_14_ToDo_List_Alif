//
//  UserViewController.swift
//  test
//
//  Created by Admin on 08/06/24.
//

import UIKit
import FirebaseAuth
import SnapKit

class UserViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        self.title = "User"
        setupLogout()
    }
    
    
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Выйти", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(nil, action: #selector(logoutButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
    }()
    

    @objc func logoutButtonTapped() {
        do {
            try Auth.auth().signOut()
            // Переход на экран входа
            let loginViewController = LoginViewController()
            let navController = UINavigationController(rootViewController: loginViewController)
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = navController
                window.makeKeyAndVisible()
            }
        } catch let signOutError as NSError {
            print("Ошибка выхода: %@", signOutError)
        }
    }
    
    
    lazy var textEmail: UILabel = {
        var text = UILabel()
        text.text = "Email: \(Auth.auth().currentUser?.email ?? "nil")"
        text.textAlignment = .center
        //text.textColor = .white
        text.font = .systemFont(ofSize: 20, weight: .semibold)
        return text
    }()


    lazy var textName: UILabel = {
        var text = UILabel()
        text.text = "Name: \(Auth.auth().currentUser?.displayName ?? "nil")"
        text.textAlignment = .center
        //text.textColor = .white
        text.font = .systemFont(ofSize: 20, weight: .semibold)
        return text
    }()
//
    
    
    
    
    private func setupLogout() {
        
        view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textEmail)
        textEmail.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(textName)
        textName.translatesAutoresizingMaskIntoConstraints = false
        
        
        textEmail.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }

        textName.snp.makeConstraints { make in
            make.top.equalTo(textEmail.snp.bottom).offset(20)
            make.width.equalTo(300)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(370)
            make.width.equalTo(200)
            make.height.equalTo(60)
            make.centerX.equalToSuperview()
        }
    }
    

    
  

}
