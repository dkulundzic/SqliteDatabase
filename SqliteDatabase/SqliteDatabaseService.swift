//
//  SqliteDatabaseService.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation
import FMDB

public enum SqliteDatabaseServiceError: Error {
    case unknown
    case cannotOpenDatabase
}

public class SqliteDatabaseService {
    
    public var isLogging = true
    
    private let databaseQueue: FMDatabaseQueue
    private let databaseInfo: SqliteDatabaseInfo
    
    public init(databaseInfo: SqliteDatabaseInfo) {
        self.databaseInfo = databaseInfo
        self.databaseQueue = FMDatabaseQueue(path: databaseInfo.getDatabasePath())
    }
    
    // MARK: -
    // MARK: Querying
    // MARK: -
    
    public func executeQuery<M: SqliteDatabaseMappable>(query: SqliteDatabaseQuery<M>, completion: @escaping ([SqliteDatabaseRow]) -> Void) {
        databaseQueue.inTransaction { (database, rollback) in
            guard let database = database else {
                return
            }
            
            do {
                try self.rows(forQuery: query, inDatabase: database, completion: { (rows) in
                    completion(rows)
                })
            } catch { }
        }
    }
    
    public func executeQuery<M: SqliteDatabaseMappable, R: Any>(query: SqliteDatabaseQuery<M>, transform: SqliteDatabaseRowTransform<R>, completion: @escaping (R) -> Void) {
        databaseQueue.inTransaction { (database, rollback) in
            guard let database = database else {
                return
            }
            
            do {
                try self.rows(forQuery: query, inDatabase: database, completion: { (rows) in
                    let transformedRows = transform.transform(rows: rows)
                    
                    completion(
                        transformedRows
                    )
                })
            } catch { }
        }
    }
    
    // MARK: -
    // MARK: Updates
    // MARK: -
    
    public func executeUpdate<M: SqliteDatabaseMappable>(update: SqliteDatabaseUpdate<M>, completion: @escaping (Bool) -> Void) {
        databaseQueue.inTransaction { (database, rollback) in
            guard let database = database else {
                return
            }
            
            completion(
                self.resolveUpdate(database: database, update: update)
            )
        }
    }
    
    // MARK: -
    // MARK: Helpers
    // MARK: -
    
    private func resolveUpdate<M: SqliteDatabaseMappable>(database: FMDatabase, update: SqliteDatabaseUpdate<M>) -> Bool {
        if let insert = update as? SqliteDatabaseInsert {
            return resolveInsert(insert: insert, database: database)
        } else if let delete = update as? SqliteDatabaseDelete {
            return resolveDelete(delete: delete, database: database)
        } else {
            return false
        }
    }
    
    private func resolveInsert<M: SqliteDatabaseMappable>(insert: SqliteDatabaseInsert<M>, database: FMDatabase) -> Bool {
        let operation = insert.replace ? "INSERT OR REPLACE": "INSERT"
        let columnsString = insert.columns.joined(separator: ",")
        let placeholders = insert.values.map({ _ in "?" }).joined(separator: ",")
        let sqlStatement = "\(operation) INTO \(insert.tableName) (\(columnsString)) VALUES (\(placeholders))"
        
        if isLogging {
            print(sqlStatement)
        }
        
        return database.executeUpdate(sqlStatement, withArgumentsIn: insert.values)
    }
    
    private func resolveDelete<M: SqliteDatabaseMappable>(delete: SqliteDatabaseDelete<M>, database: FMDatabase) -> Bool {
        return true
    }
    
    private func rows<M: SqliteDatabaseMappable>(forQuery query: SqliteDatabaseQuery<M>, inDatabase database: FMDatabase, completion: ([SqliteDatabaseRow]) -> Void) throws {
        let columnsString = query.columns.count > 0 ? query.columns.joined(separator: ","): "*"
        var sqlStatement = "SELECT \(columnsString) FROM \(query.tableName)"
        
        if let whereConstraint = query.whereClause {
            sqlStatement += " WHERE \(whereConstraint)"
        }
        
        if let limitConstraint = query.limit {
            sqlStatement += " LIMIT \(limitConstraint)"
        }
        
        if self.isLogging {
            print(sqlStatement)
        }
        
        do {
            let resultSet = try database.executeQuery(sqlStatement, values: [])
            
            defer {
                resultSet.close()
            }
            
            var rows = [SqliteDatabaseRow]()
            while resultSet.next() {
                guard let row = resultSet.resultDictionary() as? SqliteDatabaseRow else {
                    continue
                }
                
                rows.append(row)
            }
            
            completion(rows)
        } catch {
            if self.isLogging {
                print("There was an error executing: \(sqlStatement)")
            }
            
            throw SqliteDatabaseServiceError.unknown
        }
    }
    
}
