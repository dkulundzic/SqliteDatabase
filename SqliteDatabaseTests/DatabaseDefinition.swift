//
//  DatabaseDefinition.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 23/03/2017.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation
import SqliteDatabase

struct DatabaseDefinition: SqliteDatabaseDefinition {
    var metadataDefinition: [String] {
        return []
    }
    
    var tablesDefinition: [String] {
        return [
            "CREATE TABLE TODO (Id INTEGER PRIMARY KEY, Description TEXT, Completed INTEGER);"
        ]
    }
    
    var viewsDefinition: [String] {
        return []
    }
    
    var indicesDefinition: [String] {
        return []
    }
    
    var triggersDefinition: [String] {
        return []
    }
}
