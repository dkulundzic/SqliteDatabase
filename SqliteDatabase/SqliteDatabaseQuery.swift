//
//  SqliteDatabaseQuery.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 InBetweeners. All rights reserved.
//

import Foundation

/**
 A struct containing data about a single SQL join.
 */
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

/**
 Represents a single SQL Query operation. Contains all information needed to create SQL
 queries.
 
 Supports the following Query elements:
 - Where clause
 - Limit clause
 - Offset clause - only possible when combined with the Limit clause
 - Joins (types of joins are determined by the SqliteDatabaseQueryJoinType enum)
 */
public class SqliteDatabaseQuery<M: SqliteDatabaseMappable> {
    
    public let tableName: String
    public let columns: [String]
    public let whereClause: String?
    public let limit: Int?
    public let offset: Int?
    public let joins: [SqliteDatabaseQueryJoin]?
    
    public init(whereClause: String? = nil, limit: Int? = nil, offset: Int? = nil, joins: [SqliteDatabaseQueryJoin]? = nil) {
        self.tableName = M.tableName
        self.columns = M.columns
        self.whereClause = whereClause
        self.limit = limit
        self.offset = offset
        self.joins = joins
    }
}
