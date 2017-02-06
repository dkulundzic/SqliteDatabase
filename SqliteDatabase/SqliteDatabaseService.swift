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
    
    private func rows<M: SqliteDatabaseMappable>(forQuery query: SqliteDatabaseQuery<M>, inDatabase database: FMDatabase, completion: ([SqliteDatabaseRow]) -> Void) throws {
        var rows = [SqliteDatabaseRow]()
        rows.append(
            ["Description": "Test1", "Completed": true]
        )
        rows.append(
            ["Description": "Test2", "Completed": true]
        )
        rows.append(
            ["Description": "Test3", "Completed": false]
        )
        
        completion(rows)
        
        return
        
        let columnsString = query.columns.count > 0 ? query.columns.joined(separator: ","): "?"
        let sqlStatement = "SELECT \(columnsString) FROM \(query.tableName)"
        
        if self.isLogging {
            print(sqlStatement)
        }
        
        do {
            let resultSet = try database.executeQuery("", values: [])
            
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
