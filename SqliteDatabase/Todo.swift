//
//  Todo.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public struct Todo: SqliteDatabaseMappable {
    public let id: String
    public let description: String
    public let completed: Bool
    
    public init(id: String, description: String, completed: Bool = false) {
        self.id = id
        self.description = description
        self.completed = completed
    }
    
    public init?(row: SqliteDatabaseRow) {
        guard let id = row["Id"] as? String,
            let description = row["Description"] as? String,
            let completed = row["IsCompleted"] as? Bool else {
                return nil
        }
        
        self.id = id
        self.description = description
        self.completed = completed
    }
}
