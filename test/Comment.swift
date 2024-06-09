//
//  Comment.swift
//  test
//
//  Created by Admin on 09/06/24.
//

import Foundation
import Firebase

//struct Comment {
//    let id: String
//    let text: String
//    let taskId: String
//}


struct Comment {
    let id: String
    let text: String
    let author: String
    let timestamp: String
    
    init(id: String, text: String, author: String, timestamp: String) {
        self.id = id
        self.text = text
        self.author = author
        self.timestamp = timestamp
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let text = value["text"] as? String,
            let author = value["author"] as? String,
            let timestamp = value["timestamp"] as? String else {
                return nil
        }
        
        self.id = snapshot.key
        self.text = text
        self.author = author
        self.timestamp = timestamp
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "text": text,
            "author": author,
            "timestamp": timestamp
        ]
    }
}
