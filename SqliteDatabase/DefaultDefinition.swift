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
            "CREATE TABLE Todo (Id TEXT, Description TEXT, IsCompleted INTEGER)"
        ]
    }
    
    public var viewDefinition: [String] {
        return []
    }
    
    public var triggerDefinition: [String] {
        return []
    }
    
    public init() { }
    
}
