//
//  HistoryEntry.swift
//  test
//
//  Created by Admin on 10/06/24.
//

import Foundation
import Firebase

struct HistoryEntry {
    let id: String
    let timestamp: String
    let description: String
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let timestamp = value["timestamp"] as? String,
              let description = value["description"] as? String else {
            return nil
        }
        self.id = snapshot.key
        self.timestamp = timestamp
        self.description = description
    }
    
}
