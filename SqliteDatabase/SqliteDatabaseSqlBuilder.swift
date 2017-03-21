//
//  SqliteDatabaseSqlBuilder.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 17/03/2017.
//  Copyright © 2017 InBetweeners. All rights reserved.
//

import Foundation

public class SqliteDatabaseSqlBuilder {
    
    var isLogging = true
    
    private(set) var sqlStatement: String? {
        didSet {
            if let sqlStatement = sqlStatement, isLogging {
                print(sqlStatement)
            }
        }
    }
    
    public init() { }
    
    // MARK: -
    // MARK: Query statement building
    // MARK: -
    
    public func build<M: SqliteDatabaseMappable>(forQuery query: SqliteDatabaseQuery<M>) -> String {
        let columnsString = query.columns.count > 0 ? query.columns.joined(separator: ","): "?"
        
        var sqlStatement = "SELECT \(columnsString) FROM \(query.tableName)"
        
        if let joins = query.joins {
            let joinString = joins.map({ (join) -> String in
                return "\(join.joinType.rawValue.uppercased()) JOIN \(join.tableName) ON \(join.joinPredicate)"
            }).joined(separator: " ")
            
            sqlStatement += " \(joinString)"
        }
        
        if let whereClause = query.whereClause {
            sqlStatement += " WHERE \(whereClause)"
        }
        
        if let limit = query.limit {
            sqlStatement += " LIMIT \(limit)"
        }
        
        sqlStatement += ";"
        
        self.sqlStatement = sqlStatement
        
        return sqlStatement
    }
    
    // MARK: -
    // MARK: Insert statement building
    // MARK: -
    
    public func build<M: SqliteDatabaseMappable>(forInsert insert: SqliteDatabaseInsert<M>) -> String {
        return ""
    }
    
    // MARK: -
    // MARK: Update statement building
    // MARK: -
    
    public func build<M: SqliteDatabaseMappable>(forUpdate update: SqliteDatabaseUpdate<M>) -> String {
        return ""
    }
    
    // MARK: -
    // MARK: Delete statement building
    // MARK: -
    
    public func build<M: SqliteDatabaseMappable>(forDelete delete: SqliteDatabaseDelete<M>) -> String {
        return ""
    }
    
}
