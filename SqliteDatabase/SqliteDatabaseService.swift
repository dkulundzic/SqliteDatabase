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
    
    // MARK: -
    // MARK: Public properties
    // MARK: -
    
    public var isLogging = true
    
    // MARK: -
    // MARK: Private properties
    // MARK: -
    
    fileprivate let databaseQueue: FMDatabaseQueue
    fileprivate let databaseInfo: SqliteDatabaseInfo
    
    // MARK: -
    // MARK: Initialiser
    // MARK: -
    
    public init(databaseInfo: SqliteDatabaseInfo) {
        self.databaseInfo = databaseInfo
        self.databaseQueue = FMDatabaseQueue(path: databaseInfo.getDatabasePath())
    }
    
    // MARK: -
    // MARK: Private methods
    // MARK: -
    
    fileprivate func executeInTransaction(operation: @escaping (FMDatabase, UnsafeMutablePointer<ObjCBool>) -> Void) {
        databaseQueue.inTransaction { (database, rollback) in
            guard let database = database, let rollback = rollback else {
                print("Transaction failed, couldn't retrieve FMDatabase or the rollback parameter.")
                
                return
            }
            operation(database, rollback)
        }
    }
    
    fileprivate func rows<M: SqliteDatabaseMappable>(forQuery query: SqliteDatabaseQuery<M>, inDatabase database: FMDatabase, completion: ([SqliteDatabaseRow]) -> Void) throws {
        
        let columnsString = query.columns.count > 0 ? query.columns.joined(separator: ","): "?"
        let sqlStatement = "SELECT \(columnsString) FROM \(query.tableName)"
        
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

// MARK: -
// MARK: Querying
// MARK: -

extension SqliteDatabaseService {
    public func execute<M: SqliteDatabaseMappable>(query: SqliteDatabaseQuery<M>, completion: @escaping ([SqliteDatabaseRow]) -> Void) {
        
        let operation = { (database: FMDatabase, rollback: UnsafeMutablePointer<ObjCBool>) in
            do {
                try self.rows(forQuery: query, inDatabase: database, completion: { (rows) in
                    completion(rows)
                })
            } catch {
                print(error.localizedDescription)
                completion([])
            }
        }
        
        executeInTransaction(operation: operation)
    }
    
    public func execute<M: SqliteDatabaseMappable, R: Any>(query: SqliteDatabaseQuery<M>, transform: SqliteDatabaseRowTransform<R>, completion: @escaping (R) -> Void) {
        
        let operation = { (database: FMDatabase, rollback: UnsafeMutablePointer<ObjCBool>) in
            do {
                try self.rows(forQuery: query, inDatabase: database, completion: { (rows) in
                    let transformedRows = transform.transform(rows: rows)
                    
                    completion(
                        transformedRows
                    )
                })
            } catch {
                print(error.localizedDescription)
            }
        }
        
        executeInTransaction(operation: operation)
    }
}

// MARK: -
// MARK: Deletions
// MARK: -

extension SqliteDatabaseService {
    
    private func deletionSqlStatement<M: SqliteDatabaseMappable>(delete: SqliteDatabaseDelete<M>) -> String {
        return "DELETE FROM \(delete.tableName) WHERE \(delete.whereClause);".trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public func execute<M: SqliteDatabaseMappable>(delete: SqliteDatabaseDelete<M>, completion: @escaping (Bool) -> Void) {
        let sqlStatement = deletionSqlStatement(delete: delete)
        
        executeInTransaction { (database, rollback) in
            let success = database.executeStatements(sqlStatement)
            completion(success)
        }
    }
    
    public func execute<M: SqliteDatabaseMappable>(delete: SqliteDatabaseDelete<M>) -> Bool {
        let sqlStatement = deletionSqlStatement(delete: delete)
        var success = false
        
        executeInTransaction { (database, rollback) in
            success = database.executeStatements(sqlStatement)
        }
        
        return success
    }
}
