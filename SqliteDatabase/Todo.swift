//
//  Todo.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public struct Todo: SqliteDatabaseMappable {
    public let description: String
    public let completed: Bool
    
    public init(description: String, completed: Bool = false) {
        self.description = description
        self.completed = completed
    }
    
    public init?(row: SqliteDatabaseRow) {
        guard let description = row["Description"] as? String,
            let completed = row["Completed"] as? Bool else {
                return nil
        }
        
        self.description = description
        self.completed = completed
    }
}
