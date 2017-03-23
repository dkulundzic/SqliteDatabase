//
//  SqliteDatabaseSqlBuilder.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 17/03/2017.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation

public class SqliteDatabaseSqlBuilder {
    
    var isLogging = true
    
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
        
        log(sqlStatement)
        
        return sqlStatement
    }
    
    // MARK: -
    // MARK: Insert statement building
    // MARK: -
    
    public func build<M: SqliteDatabaseMappable>(forInsert insert: SqliteDatabaseInsert<M>) -> String {
        // Ensure the columns have been set.
        assert(insert.columns.count > 0)
        
        // Ensure that the values have been correctly (count-wise) mapped to the
        // columns.
        assert(insert.columns.count == insert.values.count)
        
        let operationString = insert.shouldReplace ? "INSERT OR REPLACE": "INSERT"
        let columnsString = insert.columns.joined(separator: ",")
        let columnPlaceholders = insert.columns.map { _ in "?" }.joined(separator: ",")
        let sqlStatement = "\(operationString) INTO \(insert.tableName) (\(columnsString)) VALUES (\(columnPlaceholders));"
        
        log(sqlStatement)
        
        return sqlStatement
    }
    
    // MARK: -
    // MARK: Update statement building
    // MARK: -
    
    public func build<M: SqliteDatabaseMappable>(forUpdate update: SqliteDatabaseUpdate<M>) -> String {
        // Ensure the columns have been set.
        assert(update.columnValuePairs.count > 0)
        
        let updateString = update.columnValuePairs.map { (columnValuePair) -> String in
            return "\(columnValuePair.column) = ?"
            }.joined(separator: ", ")
        
        let sqlStatement = "UPDATE \(update.tableName) SET \(updateString) WHERE \(update.whereClause);"        
        log(sqlStatement)
        
        return sqlStatement

    }
    
    // MARK: -
    // MARK: Delete statement building
    // MARK: -
    
    public func build<M: SqliteDatabaseMappable>(forDelete delete: SqliteDatabaseDelete<M>) -> String {
        let sqlStatement = "DELETE FROM \(delete.tableName) WHERE \(delete.whereClause);"
        log(sqlStatement)
        
        return sqlStatement
    }
    
    // MARK: -
    // MARK: Other
    // MARK: -
    
    private func log(_ text: CustomStringConvertible) {
        if isLogging {
            print(text)
        }
    }
}
