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
    
    private(set) var sqlStatement: String? {
        didSet {
            if let sqlStatement = sqlStatement, isLogging {
                print(sqlStatement)
            }
        }
    }
    
    public init() { }
    
    public func build<M: SqliteDatabaseMappable>(forQuery query: SqliteDatabaseQuery<M>) -> String {
        let columnsString = query.columns.count > 0 ? query.columns.joined(separator: ","): "?"
        
        var sqlStatement = "SELECT \(columnsString) FROM \(query.tableName)"
        
        if let whereClause = query.whereClause {
            sqlStatement += " WHERE \(whereClause)"
        }
        
        self.sqlStatement = sqlStatement
        
        return sqlStatement
    }
    
    public func build<M: SqliteDatabaseMappable>(forInsert insert: SqliteDatabaseInsert<M>) -> String {
        return ""
    }
    
    public func build<M: SqliteDatabaseMappable>(forUpdate update: SqliteDatabaseUpdate<M>) -> String {
        return ""
    }
    
    public func build<M: SqliteDatabaseMappable>(forDelete delete: SqliteDatabaseDelete<M>) -> String {
        return ""
    }
    
}
