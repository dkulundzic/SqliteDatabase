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
    
    public func executeUpdateOperation<M: SqliteDatabaseMappable>(update: SqliteDatabaseUpdateOperation<M>, completion: @escaping (Bool) -> Void) {
        databaseQueue.inTransaction { (database, rollback) in
            guard let database = database else {
                return
            }
            
            completion(
                self.resolveUpdateOperation(database: database, update: update)
            )
        }
    }
    
    // MARK: -
    // MARK: Helpers
    // MARK: -
    
    private func resolveUpdateOperation<M: SqliteDatabaseMappable>(database: FMDatabase, update: SqliteDatabaseUpdateOperation<M>) -> Bool {
        if let insert = update as? SqliteDatabaseInsert {
            return resolveInsert(insert: insert, database: database)
        } else if let delete = update as? SqliteDatabaseDelete {
            return resolveDelete(delete: delete, database: database)
        } else if let update = update as? SqliteDatabaseUpdate {
            return resolveUpdate(update: update, database: database)
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
        
        return database.executeUpdate(sqlStatement, withArgumentsIn: insert.values as [Any])
    }
    
    private func resolveDelete<M: SqliteDatabaseMappable>(delete: SqliteDatabaseDelete<M>, database: FMDatabase) -> Bool {
        let sqlStatement = "DELETE FROM \(delete.tableName) WHERE \(delete.whereClause)"
        
        if isLogging {
            print(sqlStatement)
        }
        
        return database.executeStatements(sqlStatement)
    }
    
    private func resolveUpdate<M: SqliteDatabaseMappable>(update: SqliteDatabaseUpdate<M>, database: FMDatabase) -> Bool {
        let updatePairString = update.columns.map({ return "\($0) = ?" }).joined(separator: ",")
        let sqlStatement = "UPDATE \(update.tableName) SET \(updatePairString) WHERE \(update.whereClause)"
        
        if isLogging {
            print(sqlStatement)
        }
        
        return database.executeUpdate(sqlStatement, withArgumentsIn: update.values)
    }
    
    private func rows<M: SqliteDatabaseMappable>(forQuery query: SqliteDatabaseQuery<M>, inDatabase database: FMDatabase, completion: ([SqliteDatabaseRow]) -> Void) throws {
        let columnsString = query.columns.count > 0 ? query.columns.joined(separator: ","): "*"
        var sqlStatement = "SELECT \(columnsString) FROM \(query.tableName)"
        
        if let whereConstraint = query.whereClause, !whereConstraint.isEmpty {
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
