//
//  SqliteDatabaseInitialisation.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 06/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation
import FMDB

public enum SqliteDatabaseInitialisationError: Error {
    case alreadyExists
    case sqlError
}

final public class SqliteDatabaseInitialisation {
    
    public let databaseInfo: SqliteDatabaseInfo
    public let databaseDefinition: SqliteDatabaseDefinitionProtocol
    
    public init(databaseInfo: SqliteDatabaseInfo, databaseDefinition: SqliteDatabaseDefinitionProtocol) {
        self.databaseInfo = databaseInfo
        self.databaseDefinition = databaseDefinition
    }
    
    public func initialise(completion: (SqliteDatabaseInitialisationError?) -> Void) {
        let path = databaseInfo.getDatabasePath()
        print("Initialising database at \(path)")
        
        guard !FileManager.default.fileExists(atPath: path) else {
            completion(SqliteDatabaseInitialisationError.alreadyExists)
            
            return
        }
        
        guard let database = FMDatabase(path: path) else {
            completion(SqliteDatabaseInitialisationError.sqlError)
            
            return
        }
        
        defer {
            database.close()
            completion(nil)
        }
        
        database.open()
        database.executeStatements(
            tableCreationStatement()
        )
        
        database.executeStatements(
            viewCreationStatement()
        )
        
        database.executeStatements(
            triggerCreationStatement()
        )
    }
    
    private func tableCreationStatement() -> String {
        return databaseDefinition.tableDefinition.joined(separator: "")
    }
    
    private func viewCreationStatement() -> String {
        return databaseDefinition.viewDefinition.joined(separator: "")
    }
    
    private func triggerCreationStatement() -> String {
        return databaseDefinition.triggerDefinition.joined(separator: "")
    }
}
