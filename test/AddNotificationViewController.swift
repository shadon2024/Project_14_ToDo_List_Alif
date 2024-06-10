//
//  PushViewController.swift
//  test
//
//  Created by Admin on 10/06/24.
//

import UIKit



protocol AddNotificationDelegate: AnyObject {
    func didAddNotification(_ notification: Notification)
}

class AddNotificationViewController: UIViewController {

    weak var delegate: AddNotificationDelegate?

    var notificationTimePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Добавить оповещение"
        view.backgroundColor = .white

        setupViews()
        setupConstraints()
    }

    func setupViews() {
        notificationTimePicker = UIDatePicker()
        notificationTimePicker.datePickerMode = .dateAndTime
        view.addSubview(notificationTimePicker)

        let addButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    func setupConstraints() {
        notificationTimePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            notificationTimePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notificationTimePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func addButtonTapped() {
        let notification = Notification(time: notificationTimePicker.date)
        delegate?.didAddNotification(notification)
        navigationController?.popViewController(animated: true)
    }
}



struct Notification {
    let time: Date
}

class NotificationTableViewCell: UITableViewCell {

    func configure(with notification: Notification) {
        // Настройка ячейки с данными оповещения
    }
}
