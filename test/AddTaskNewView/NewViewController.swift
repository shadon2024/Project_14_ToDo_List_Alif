//
//  NewViewController.swift
//  test
//
//  Created by Admin on 11/06/24.
//

import UIKit

class NewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    

    private func setupViews() {
        self.title = "Test"
        view.backgroundColor = .white
        
        // Создаем кнопку добавления задачи в панели навигации
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskButtonTapped))
        navigationItem.rightBarButtonItem = addButton // Устанавливаем кнопку в правой части навигационной панели
    }


    @objc func addTaskButtonTapped() {
        let detailView = DetailViewController()
        let nav = UINavigationController(rootViewController: detailView)
        nav.modalPresentationStyle = .pageSheet
        
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        
        present(nav, animated: true, completion: nil)
    }
    
}
