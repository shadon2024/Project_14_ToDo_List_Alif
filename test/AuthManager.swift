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
