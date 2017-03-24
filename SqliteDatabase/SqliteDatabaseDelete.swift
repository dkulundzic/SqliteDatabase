//
//  SqliteDatabaseDelete.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 16/03/2017.
//  Copyright © 2017 InBetweeners. All rights reserved.
//

import Foundation

/**
 Represents a single SQL Delete operation.
 */
public class SqliteDatabaseDelete<M: SqliteDatabaseMappable> {
    public let tableName: String
    public let whereClause: String
    
    public init(whereClause: String) {
        self.tableName = M.tableName
        self.whereClause = whereClause
    }
}
