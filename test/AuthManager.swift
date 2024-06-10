//
//  AuthManager.swift
//  test
//
//  Created by Admin on 09/06/24.
//

import Foundation
import FirebaseAuth
import UIKit

//class AuthManager {
//    static let shared = AuthManager()
//
//    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
//        // Ваш код для аутентификации пользователя
//        // После успешной аутентификации вызовите этот блок
//
//         let user = Auth.auth().currentUser
//            // В этой точке у вас есть объект user с информацией о текущем пользователе
//        let userEmail = user?.email
//        let userName = user?.displayName
//            // Теперь у вас есть email и displayName (имя пользователя) для передачи на UserViewController
//
//
//        // Передаем данные на UserViewController
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
//           let window = appDelegate.window,
//           let tabBarController = window.rootViewController as? UITabBarController,
//           let navController = tabBarController.viewControllers?.first as? UINavigationController,
//           let userVC = navController.viewControllers.first as? UserViewController {
//            userVC.textEmail.text = userEmail
//            userVC.textName.text = userName
//               tabBarController.selectedIndex = 0
//        }
//
//        completion(true)
//    }
//}

//class AuthManager {
//    static let shared = AuthManager()
//
//    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
//            guard let user = authResult?.user, error == nil else {
//                print("Ошибка входа пользователя:", error?.localizedDescription ?? "Неизвестная ошибка")
//                completion(false)
//                return
//            }
//
//            // Получаем информацию о пользователе
//            let userEmail = user.email
//            let userName = user.displayName
//
//            // Передаем информацию на UserViewController
//            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
//               let window = appDelegate.window,
//               let tabBarController = window.rootViewController as? UITabBarController,
//               let navController = tabBarController.viewControllers?.first as? UINavigationController,
//               let userVC = navController.viewControllers.first as? UserViewController {
//                userVC.textEmail.text = userEmail
//                userVC.textName.text = userName
//                   tabBarController.selectedIndex = 0
//            }
//
//            completion(true)
//        }
//    }
//}



//@objc func addTaskButtonTapped() {
//    let alert = UIAlertController(title: "Новая задача", message: "Введите информацию о задаче", preferredStyle: .alert)
//    alert.addTextField { textField in
//        textField.placeholder = "Название задачи"
//    }
//    alert.addTextField { textField in
//        textField.placeholder = "Описание задачи"
//    }
//
//    let statusSegmentedControl = UISegmentedControl(items: ["В работе", "Ожидание", "Закрыта"])
//    statusSegmentedControl.selectedSegmentIndex = 0
//    alert.view.addSubview(statusSegmentedControl)
//
//    statusSegmentedControl.snp.makeConstraints { make in
//        make.top.equalTo(alert.textFields!.last!.snp.bottom).offset(10)
//        make.centerX.equalTo(alert.view)
//        make.width.equalTo(250)
//    }
//
//    alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
//    alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { _ in
//        guard let name = alert.textFields?[0].text, !name.isEmpty,
//              let description = alert.textFields?[1].text else { return }
//
//        let status = statusSegmentedControl.titleForSegment(at: statusSegmentedControl.selectedSegmentIndex) ?? "В работе"
//        let taskId = self.ref.childByAutoId().key ?? UUID().uuidString
//        let newTask = Task(id: taskId, name: name, description: description, status: status, executor: "Не назначен", deadline: "Не указан")
//
//        self.ref.child(taskId).setValue(newTask.toDictionary())
//    }))
//
//    present(alert, animated: true, completion: nil)
//}
