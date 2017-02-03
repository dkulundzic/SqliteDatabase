//
//  SqliteDatabaseQuery.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public class SqliteDatabaseQuery<M: SqliteDatabaseMappable> {
    let tableName: String
    let columns: [String]
    
    public init(sqliteDatabaseMappable: M) {
        self.tableName = M.tableName
        self.columns = M.columns
    }
}
