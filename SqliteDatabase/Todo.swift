//
//  Todo.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 InBetweeners. All rights reserved.
//

import Foundation
import SqliteDatabase

public struct Todo {
    public let description: String
    public let completed: Bool
    
    public init(description: String, completed: Bool = false) {
        self.description = description
        self.completed = completed
    }
}

extension Todo: SqliteDatabaseMappable {
    
    public static var columns: [String] {
        return [
            "Description",
            "Completed"
        ]
    }
    
    public init?(row: SqliteDatabaseRow) {
        guard let description = row["Description"] as? String,
            let completed = row["Completed"] as? Bool else {
                return nil
        }
        
        self.description = description
        self.completed = completed
    }
    
    public func values() -> [Any?] {
        var values = [Any?]()
        
        values.append(description as Any?)
        values.append(completed as Any?)
        
        return values
    }
    
}
