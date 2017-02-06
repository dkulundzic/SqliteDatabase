//
//  SqliteDatabaseUpdateOperation.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 06/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public class SqliteDatabaseUpdateOperation<M: SqliteDatabaseMappable> {
    public let tableName: String
    
    public init() {
        self.tableName = M.tableName
    }
}
