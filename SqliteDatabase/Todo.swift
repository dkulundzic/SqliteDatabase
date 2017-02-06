//
//  Todo.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public struct Todo {
    public var id: Int!
    public let description: String
    public let completed: Bool
    
    public init(description: String, completed: Bool = false) {
        self.description = description
        self.completed = completed
    }
}

extension Todo: SqliteDatabaseMappable {
    
    public init?(row: SqliteDatabaseRow) {
        guard let id = row["Id"] as? Int,
            let description = row["Description"] as? String,
            let completed = row["IsCompleted"] as? Bool else {
                return nil
        }
        
        self.id = id
        self.description = description
        self.completed = completed
    }
    
    public static var columns: [String] {
        return [
            "Description",
            "IsCompleted"
        ]
    }
    
    public var values: [Any?] {
        return [description, completed].map({ $0 as AnyObject?})
    }
    
}
