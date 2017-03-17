//
//  SqliteDatabaseQuery.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public struct SqliteDatabaseQueryInnerJoin {
    public let tableName: String
    public let joinPredicate: String
    
    public init(tableName: String, joinPredicate: String) {
        self.tableName = tableName
        self.joinPredicate = joinPredicate
    }
}

public class SqliteDatabaseQuery<M: SqliteDatabaseMappable> {
    
    public let tableName: String
    public let columns: [String]
    public let whereClause: String?
    public let limit: Int?
    public let innerJoins: [SqliteDatabaseQueryInnerJoin]?
    
    public init(whereClause: String? = nil, limit: Int? = nil, innerJoins: [SqliteDatabaseQueryInnerJoin]? = nil) {
        self.tableName = M.tableName
        self.columns = M.columns
        self.whereClause = whereClause
        self.limit = limit
        self.innerJoins = innerJoins
    }
}
