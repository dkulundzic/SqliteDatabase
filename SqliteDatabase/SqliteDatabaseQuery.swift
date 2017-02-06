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
    
    var whereClause: String?
    var limit: Int?
    
    public init(tableName: String, columns: [String], whereClause: String? = nil, limit: Int? = nil) {
        self.tableName = tableName
        self.columns = columns
        self.whereClause = whereClause
        self.limit = limit
    }
    
    public init(whereClause: String? = nil, limit: Int? = nil) {
        self.tableName = M.tableName
        self.columns = M.columns
        
        self.whereClause = whereClause
        self.limit = limit
    }
}
