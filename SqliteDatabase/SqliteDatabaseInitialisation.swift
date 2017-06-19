//
//  SqliteDatabaseInitialisation.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 23/03/2017.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation
import FMDB

/**
 The class takes care of initialising  the SQLite database at a location specified by a
 SqliteDatabaseInfo instance. 
 
 The initialisation process executes in the following steps:
 - Check whether a database exists at the specified file path, delete if true.
 - Attempt to create and open a database at the specified file path.
 - Execute SqliteDatabaseDefinition statements following the order specified within the "initialise" method.
 - Close the database connection.
 */
public class SqliteDatabaseInitialisation {
    
    // MARK: -
    // MARK: Properties
    // MARK: -
    
    let databaseDefinition: SqliteDatabaseDefinition
    
    // MARK: -
    // MARK: Initialisers
    // MARK: -
    
    public init(databaseDefinition: SqliteDatabaseDefinition) {
        self.databaseDefinition = databaseDefinition
    }
    
    // MARK: -
    // MARK: API
    // MARK: -
    
    /**
     Using the provided database info, the class will create a .sqlite database at the
     database info path and execute the definition statementsi in the following order:
     - metadata
     - table
     - view
     - index
     - trigger
     - post creation statements
     
     the operation will immediately fail if any of these statements fail. 
     
     - note: If a database currently exists at the specified location, it will be deleted and 
     recreated, executing the definition statements from scratch.
     
     - parameter databaseInfo: A SqliteDatabaseInfo instance defining the path of the database.
     
     */
    public func initialise(withDatabaseInfo databaseInfo: SqliteDatabaseInfo, deleteIfExists: Bool = false) -> Bool {
        // If a database already exists at the path, successfully return.
        if SqliteDatabaseUtility.databaseExists(atPath: databaseInfo.getDatabasePath()), deleteIfExists {
            print("SqliteDatabaseInitialisation: database already exists at \(databaseInfo.getDatabasePath()), deleting.")
            
            guard SqliteDatabaseUtility.remove(atPath: databaseInfo.getDatabasePath()) else {
                print("SqliteDatabaseInitialisation: unable to remove database at \(databaseInfo.getDatabasePath()).")
                return false
            }
        }
        
        // Attempt to create a database at the specified file path.
        let database = FMDatabase(path: databaseInfo.getDatabasePath())
        
        // Attempt to open the database.
        guard database.open() else {
            print("SqliteDatabaseInitialisation: failed opening database at \(databaseInfo.getDatabasePath()).")
            
            return false
        }
        
        // Ensure the database connection gets closed if open.
        defer {
            database.close()
        }
        
        if let metadataSQLStatements = metadataSQLStatements() {
            guard database.executeStatements(metadataSQLStatements) else {
                print("SqliteDatabaseInitialisation: failed executing metadata statements --> \(metadataSQLStatements) because \(database.lastError().localizedDescription).")
                
                return false
            }
        }
        
        if let tableSQLStatements = tableSQLStatements() {
            guard database.executeStatements(tableSQLStatements) else  {
                print("SqliteDatabaseInitialisation: failed executing table statements --> \(tableSQLStatements) because \(database.lastError().localizedDescription).")
                
                return false
            }
        }
        
        if let viewSQLStatements = viewSQLStatements() {
            guard database.executeStatements(viewSQLStatements) else  {
                print("SqliteDatabaseInitialisation: failed executing view statements --> \(viewSQLStatements) because \(database.lastError().localizedDescription).")
                
                return false
            }
        }
        
        if let indexSQLStatements = indexSQLStatements() {
            guard database.executeStatements(indexSQLStatements) else  {
                print("SqliteDatabaseInitialisation: failed executing index statements --> \(indexSQLStatements) because \(database.lastError().localizedDescription).")
                
                return false
            }
        }
        
        if let triggerSQLStatements = triggerSQLStatements() {
            guard database.executeStatements(triggerSQLStatements) else  {
                print("SqliteDatabaseInitialisation: failed executing trigger statements --> \(triggerSQLStatements) because \(database.lastError().localizedDescription).")
                
                return false
            }
        }
        
        if let postCreationSQLStatements = postCreationSQLStatements() {
            if !database.executeStatements(postCreationSQLStatements) {
                print("SqliteDatabaseInitialisation: failed executing trigger statements --> \(postCreationSQLStatements) because \(database.lastError().localizedDescription).")
            }
        }
        
        return true
    }
    
    // MARK: -
    // MARK: SQL Statement creation
    // MARK: -
    
    private func metadataSQLStatements() -> String? {
        guard databaseDefinition.metadataDefinition.count > 0 else {
            return nil
        }
        
        return databaseDefinition.metadataDefinition.joined(separator: "")
    }
    
    private func tableSQLStatements() -> String? {
        guard databaseDefinition.tablesDefinition.count > 0 else {
            return nil
        }
        
        return databaseDefinition.tablesDefinition.joined(separator: "")
    }
    
    private func viewSQLStatements() -> String? {
        guard databaseDefinition.viewsDefinition.count > 0 else {
            return nil
        }
        
        return databaseDefinition.viewsDefinition.joined(separator: "")
    }
    
    private func indexSQLStatements() -> String? {
        guard databaseDefinition.indicesDefinition.count > 0 else {
            return nil
        }
        
        return databaseDefinition.indicesDefinition.joined(separator: "")
    }
    
    private func triggerSQLStatements() -> String? {
        guard databaseDefinition.triggersDefinition.count > 0 else {
            return nil
        }
        
        return databaseDefinition.triggersDefinition.joined(separator: "")
    }
    
    private func postCreationSQLStatements() -> String? {
        guard databaseDefinition.postCreationStatements.count > 0 else {
            return nil
        }
        
        return databaseDefinition.postCreationStatements.joined(separator: "")
    }
    
}
