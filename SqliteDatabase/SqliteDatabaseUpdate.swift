//
//  SqliteDatabaseUpdate.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 17/03/2017.
//  Copyright © 2017 InBetweeners. All rights reserved.
//

import Foundation

/**
 Represents a single Column-Value pairing. Ensures and enforces correct binding.
 */
public struct SqliteDatabaseUpdateColumnValuePair {
    public let column: String
    public let value: Any?
    
    public init(column: String, value: Any?) {
        self.column = column
        self.value = value
    }
}

/**
 Represents a single Update SQL operation.
 */
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
