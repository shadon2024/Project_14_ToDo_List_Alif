//
//  Task.swift
//  test
//
//  Created by Admin on 09/06/24.
//

import Foundation
import Firebase


// Определяем перечисление для статусов задач
enum TaskStatus: String {
    case inProgress = "В работе"
    case pending = "Ожидание"
    case completed = "Закрыта"
}


// Создаем структуру для представления задачи
struct Task {
    let id: String // Уникальный идентификатор задачи
    let name: String // Название задачи
    let description: String // Описание задачи
    let status: String // Статус задачи (используем String, но лучше бы использовать TaskStatus из перечисления)
    let executor: String // Исполнитель задачи
    let deadline: String // Срок выполнения задачи
    let director: String // Директор (назначивший) задачу
}
