//
//  SqliteDatabaseService.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 InBetweeners. All rights reserved.
//

import Foundation
import FMDB

public enum SqliteDatabaseServiceError: Error {
    case error(String)
}

public class SqliteDatabaseService {
    
    // MARK: -
    // MARK: Public properties
    // MARK: -
    
    public var isLogging = false
    
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
            operation(database, rollback)
        }
    }
}

// MARK: -
// MARK: Querying
// MARK: -

extension SqliteDatabaseService {
    private func rows<M: SqliteDatabaseMappable>(forQuery query: SqliteDatabaseQuery<M>, inDatabase database: FMDatabase, completion: ([SqliteDatabaseRow], SqliteDatabaseServiceError?) -> Void) throws {
        let sqlStatement = SqliteDatabaseSqlBuilder(isLogging: isLogging).build(forQuery: query)
        
        do {
            let resultSet = try database.executeQuery(sqlStatement, values: [])
            
            defer {
                resultSet.close()
            }
            
            var rows = [SqliteDatabaseRow]()
            
            while resultSet.next() {
                guard let row = resultSet.resultDictionary as? SqliteDatabaseRow else {
                    continue
                }
                
                rows.append(row)
            }
            
            completion(rows, nil)
        } catch {
            if self.isLogging {
                print("There was an error executing: \(sqlStatement) becuase \(error.localizedDescription)")
            }
            
            completion([], .error(error.localizedDescription))
        }
    }
    
    /**
     Executes a Query against the database (using a SqliteDatabaseQuery instance).
     
     - parameter query: A SqliteDatabaseQuery instance.
     - parameter completion: A closure to be invoked upon operation completion.
     */
    public func execute<M: SqliteDatabaseMappable>(query: SqliteDatabaseQuery<M>, completion: @escaping ([SqliteDatabaseRow], SqliteDatabaseServiceError?) -> Void) {
        
        let operation = { (database: FMDatabase, rollback: UnsafeMutablePointer<ObjCBool>) in
            do {
                try self.rows(forQuery: query, inDatabase: database, completion: { (rows, error) in
                    completion(rows, error)
                })
            } catch {
                print(error.localizedDescription)
                completion([], .error(error.localizedDescription))
            }
        }
        
        executeInTransaction(operation: operation)
    }
    
    /**
     Executes a Query against the database (using a SqliteDatabaseQuery instance).
     
     - parameter query: A SqliteDatabaseQuery instance.
     - parameter completion: A closure to be invoked upon operation completion.
     */
    public func execute<M: SqliteDatabaseMappable>(query: SqliteDatabaseQuery<M>, completion: @escaping ([M], SqliteDatabaseServiceError?) -> Void) {
        
        let operation = { (database: FMDatabase, rollback: UnsafeMutablePointer<ObjCBool>) in
            do {
                try self.rows(forQuery: query, inDatabase: database, completion: { (rows, error) in
                    let entities = rows.flatMap(M.init)
                    completion(entities, error)
                })
            } catch {
                print(error.localizedDescription)
                completion([], .error(error.localizedDescription))
            }
        }
        
        executeInTransaction(operation: operation)
    }
    
    /**
     Executes a Query against the database (using a SqliteDatabaseQuery instance) with a SqliteDatabaseRowTransform instance
     to transform the rows retrieved.
     
     - parameter query: A SqliteDatabaseQuery instance.
     - parameter transform: A SqliteDatabaseRowTransform instance specifying the row transformation.
     - parameter completion: A closure to be invoked upon operation completion.
     */
    public func execute<M: SqliteDatabaseMappable, R: Any>(query: SqliteDatabaseQuery<M>, transform: SqliteDatabaseRowTransform<R>, completion: @escaping (R?, SqliteDatabaseServiceError?) -> Void) {
        
        let operation = { (database: FMDatabase, rollback: UnsafeMutablePointer<ObjCBool>) in
            do {
                try self.rows(forQuery: query, inDatabase: database, completion: { (rows, error) in
                    guard error == nil else {
                        completion(nil, .error(error!.localizedDescription))
                        return
                    }
                    
                    let transformedRows = transform.transform(rows: rows)
                    
                    completion(transformedRows, nil)
                })
            } catch {
                print(error.localizedDescription)
                completion(nil, .error(error.localizedDescription))
            }
        }
        
        executeInTransaction(operation: operation)
    }
}

// MARK: -
// MARK: Deletion
// MARK: -

extension SqliteDatabaseService {
    
    /**
     Executes a Delete against the database (using a SqliteDatabaseDelete instance).
     
     - parameter delete: A SqliteDatabaseDelete instance.
     - parameter completion: A closure to invoke upon operation completion.
     */
    public func execute<M: SqliteDatabaseMappable>(delete: SqliteDatabaseDelete<M>, completion: @escaping (Bool) -> Void) {
        let sqlStatement = SqliteDatabaseSqlBuilder(isLogging: isLogging).build(forDelete: delete)
        
        executeInTransaction { (database, rollback) in
            let success = database.executeStatements(sqlStatement)
            completion(success)
        }
    }
    
    /**
     Executes a Delete against the database (using a SqliteDatabaseDelete instance).
     
     - parameter delete: A SqliteDatabaseDelete instance.
     
     - returns: True if the operation was successful, otherwise returns false.
     */
    public func execute<M: SqliteDatabaseMappable>(delete: SqliteDatabaseDelete<M>) -> Bool {
        let sqlStatement = SqliteDatabaseSqlBuilder(isLogging: isLogging).build(forDelete: delete)
        var success = false
        
        executeInTransaction { (database, rollback) in
            success = database.executeStatements(sqlStatement)
        }
        
        return success
    }
}

// MARK: -
// MARK: Insertion
// MARK: -

extension SqliteDatabaseService {
    private func _execute<M: SqliteDatabaseMappable>(insert: SqliteDatabaseInsert<M>) -> Int64? {
        let sqlStatement = SqliteDatabaseSqlBuilder(isLogging: isLogging).build(forInsert: insert)
        var rowId: Int64?
        
        executeInTransaction { (database, rollback) in
            do {
                try database.executeUpdate(sqlStatement, values: insert.values)
                rowId = database.lastInsertRowId
            } catch {
                if self.isLogging {
                    print(error.localizedDescription)
                }
            }
        }
        
        return rowId
    }
    
    /**
     Executes a Insert against the database (using a SqliteDatabaseInsert instance).
     
     - parameter insert: A SqliteDatabaseInsert instance.
     - parameter completion: A closure to invoke upon operation completion.
     */
    public func execute<M: SqliteDatabaseMappable>(insert: SqliteDatabaseInsert<M>, completion: @escaping (Int64?) -> Void) {
        let rowId = _execute(insert: insert)
        
        completion(rowId)
    }
    
    /**
     Executes a Insert against the database (using a SqliteDatabaseInsert instance).
     
     - parameter insert: A SqliteDatabaseInsert instance.
     
     - returns: True if the operation was successful, otherwise returns false.
     */
    public func execute<M: SqliteDatabaseMappable>(insert: SqliteDatabaseInsert<M>) -> Int64? {
        return _execute(insert: insert)
    }
}

// MARK: -
// MARK: Update
// MARK: -

extension SqliteDatabaseService {
    private func _execute<M: SqliteDatabaseMappable>(update: SqliteDatabaseUpdate<M>) -> Bool {
        let sqlStatement = SqliteDatabaseSqlBuilder(isLogging: isLogging).build(forUpdate: update)
        var success = false
        
        let values = update.columnValuePairs.map { $0.value }
        
        executeInTransaction { (database, rollback) in
            do {                
                try database.executeUpdate(sqlStatement, values: values)
                success = true
            } catch {
                if self.isLogging {
                    print(error.localizedDescription)
                }
            }
        }
        
        return success
    }
    
    /**
     Executes a Update against the database (using a SqliteDatabaseUpdate instance).
     
     - parameter update: A SqliteDatabaseUpdate instance.
     - parameter completion: A closure to invoke upon operation completion.
     */
    public func execute<M: SqliteDatabaseMappable>(update: SqliteDatabaseUpdate<M>, completion: @escaping (Bool) -> Void) {
        let success = _execute(update: update)
        
        completion(success)
    }
    
    /**
     Executes a Update against the database (using a SqliteDatabaseUpdate instance).
     
     - parameter update: A SqliteDatabaseUpdate instance.
     
     - returns: True if the operation was successful, otherwise returns false.
     */
    public func execute<M: SqliteDatabaseMappable>(update: SqliteDatabaseUpdate<M>) -> Bool {
        return _execute(update: update)
    }
    
}
