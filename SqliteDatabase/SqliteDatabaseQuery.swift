//
//  SqliteDatabaseQuery.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 InBetweeners. All rights reserved.
//

import Foundation

public struct SqliteDatabaseQueryJoin {
    public enum SqliteDatabaseQueryJoinType: String {
        case inner = "inner"
        case left = "left"
    }
    
    public let tableName: String
    public let joinPredicate: String
    public let joinType: SqliteDatabaseQueryJoinType
    
    public init(joinType: SqliteDatabaseQueryJoinType, tableName: String, joinPredicate: String) {
        self.joinType = joinType
        self.tableName = tableName
        self.joinPredicate = joinPredicate
    }
}

public class SqliteDatabaseQuery<M: SqliteDatabaseMappable> {
    
    public let tableName: String
    public let columns: [String]
    public let whereClause: String?
    public let limit: Int?
    public let joins: [SqliteDatabaseQueryJoin]?
    
    public init(whereClause: String? = nil, limit: Int? = nil, joins: [SqliteDatabaseQueryJoin]? = nil) {
        self.tableName = M.tableName
        self.columns = M.columns
        self.whereClause = whereClause
        self.limit = limit
        self.joins = joins
    }
}
