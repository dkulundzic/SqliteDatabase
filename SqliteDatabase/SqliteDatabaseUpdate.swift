//
//  SqliteDatabaseUpdate.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 17/03/2017.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public struct SqliteDatabaseUpdateColumnValuePair {
    public let column: String
    public let value: Any?
    
    public init(column: String, value: Any?) {
        self.column = column
        self.value = value
    }
}

public class SqliteDatabaseUpdate<M: SqliteDatabaseMappable> {
    
    public let tableName: String
    public let columnValuePairs: [SqliteDatabaseUpdateColumnValuePair]
    public let whereClause: String
    
    public init(columnValuePairs: [SqliteDatabaseUpdateColumnValuePair], whereClause: String) {
        self.tableName = M.tableName
        self.columnValuePairs = columnValuePairs
        self.whereClause = whereClause
    }
}
