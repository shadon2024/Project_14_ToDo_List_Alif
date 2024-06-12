//
//  ListUser.swift
//  test
//
//  Created by Admin on 11/06/24.
//

import Foundation
import Firebase

// Создаем структуру
struct ListUser {
    let id: String
    let email: String
    let name: String
    
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.name = data["name"] as! String
        self.email = data["email"] as! String
    }
    
    init(id: String, email: String, name: String) {
        self.id = id
        self.email = email
        self.name = name
    }

    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let id = value["id"] as? String,
              let email = value["email"] as? String,
              let name = value["name"] as? String else {
            return nil
        }

        self.id = id
        self.email = email
        self.name = name
    }
    
    
    
 
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "email": email,
            "name": name
        ]
    }
}
