//
//  Todo.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
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
    
    public func values() -> [AnyObject?] {
        var values = [AnyObject?]()
        
        values.append(description as AnyObject?)
        values.append(completed as AnyObject?)
        
        return values
    }
    
}
