//
//  Task.swift
//  test
//
//  Created by Admin on 09/06/24.
//

import Foundation
import Firebase


enum TaskStatus: String {
    case inProgress = "В работе"
    case pending = "Ожидание"
    case completed = "Закрыта"
}


struct Task {
    let id: String
    let name: String
    let description: String
    let status: String
    let executor: String
    let deadline: String
    let director: String
    
    
    
    // Добавим статический метод для получения списка возможных исполнителей
       static func availableExecutors() -> [String] {
           // Возвращаем предопределенный список исполнителей (можно получить из базы данных или задать статически)
           return ["Исполнитель 1", "Исполнитель 2", "Исполнитель 3"]
       }
    
    
//    init(id: String, name: String, description: String, status: String, executor: String, deadline: String, director: String) {
//        self.id = id
//        self.name = name
//        self.description = description
//        self.status = status
//        self.executor = executor
//        self.deadline = deadline
//        self.director = director
//    }
//
//    init?(snapshot: DataSnapshot) {
//        guard
//            let value = snapshot.value as? [String: AnyObject],
//            let name = value["name"] as? String,
//            let description = value["description"] as? String,
//            let statusString = value["status"] as? String,
//            let status = TaskStatus(rawValue: statusString),
//            let executor = value["executor"] as? String,
//            let deadline = value["deadline"] as? String,
//            let director = value["director"] as? String else {
//            return nil
//        }
//
//        self.id = snapshot.key
//        self.name = name
//        self.description = description
//        self.status = status.rawValue
//        self.executor = executor
//        self.deadline = deadline
//        self.director = director
//
//
//        func toDictionary() -> [String: Any] {
//            return [
//                "name": name,
//                "description": description,
//                "status": status.rawValue,
//                "executor": executor,
//                "deadline": deadline,
//                "director": director
//            ]
//        }
//    }
}
