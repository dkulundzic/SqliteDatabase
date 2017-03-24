//
//  SqliteDatabaseInitialisation.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 23/03/2017.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import Foundation
import FMDB

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
     
     the operation will immediately fail if any of these statements fail. 
     
     - note: If a database currently exists at the specified location, it will be deleted and 
     recreated, executing the definition statements from scratch.
     
     - parameter databaseInfo: A SqliteDatabaseInfo instance defining the path of the database.
     
     */
    public func initialise(withDatabaseInfo databaseInfo: SqliteDatabaseInfo) -> Bool {
        print(databaseInfo.getDatabasePath())
        
        // If a database already exists at the path, successfully return.
        if databaseExists(at: databaseInfo.getDatabasePath()) {
            print("SqliteDatabaseInitialisation: database already exists at \(databaseInfo.getDatabasePath()), deleting.")
            
            guard remove(at: databaseInfo.getDatabasePath()) else {
                print("SqliteDatabaseInitialisation: unable to remove database at \(databaseInfo.getDatabasePath()).")
                return false
            }
        }
        
        // Attempt to create a database at the specified file path.
        guard let database = FMDatabase(path: databaseInfo.getDatabasePath()) else {
            print("SqliteDatabaseInitialisation: failed creating database at \(databaseInfo.getDatabasePath()).")
            
            return false
        }
        
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
    
    /**
     Checks whether a database exists at the specified path. The path should be fully specified.
     
     - parameter path: The database file path.
     - returns: True if the file exists, false if it does not.
     */
    public func databaseExists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    /**
     Attempts to remove the database at the specified path.
     
     - note: This method will print out a error if the file deletion throws.
     
     - parameter path: The database file path.
     - returns: True if the file was successfully removed, false if it was not.
     */
    public func remove(at path: String) -> Bool {        
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
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
