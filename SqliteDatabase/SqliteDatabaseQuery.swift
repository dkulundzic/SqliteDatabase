//
//  SqliteDatabaseQuery.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public class SqliteDatabaseQuery<M: SqliteDatabaseMappable> {
    public let tableName: String
    public let columns: [String]
    public let whereClause: String?
    
    public init(whereClause: String? = nil) {
        self.tableName = M.tableName
        self.columns = M.columns
        self.whereClause = whereClause
    }
}
