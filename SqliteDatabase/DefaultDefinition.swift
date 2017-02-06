//
//  DefaultDefinition.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 06/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public class DefaultDefinition: SqliteDatabaseDefinitionProtocol {
    
    public var tableDefinition: [String] {
        return [
            "CREATE TABLE Todo (Id TEXT UNIQUE, Description TEXT, IsCompleted INTEGER)"
        ]
    }
    
    public var viewDefinition: [String] {
        return []
    }
    
    public var triggerDefinition: [String] {
        return []
    }
    
    public var customStatements: [String]? {
        return [
            "INSERT OR REPLACE INTO Todo (Id, Description, IsCompleted) VALUES (\"3KFKO-DKOAO-3123KO\", \"Clean up the apartment a bit\", 0);",
            "INSERT OR REPLACE INTO Todo (Id, Description, IsCompleted) VALUES (\"1KFKO-DKOAO-8871KO\", \"Cook dinner\", 0);",
            "INSERT OR REPLACE INTO Todo (Id, Description, IsCompleted) VALUES (\"4KFKO-DKOAO-9047KO\", \"Have fun\", 0);"
        ]
    }
    
    public init() { }
    
}
