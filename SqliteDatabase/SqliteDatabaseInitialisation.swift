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
     
     - parameter databaseInfo: A SqliteDatabaseInfo instance defining the path of the database.
     
     */
    public func initialise(withDatabaseInfo databaseInfo: SqliteDatabaseInfo) -> Bool {
        print(databaseInfo.getDatabasePath())
        
        // If a database already exists at the path, successfully return.
        guard !databaseExists(at: databaseInfo.getDatabasePath()) else {
            print("SqliteDatabaseInitialisation: database already exists at \(databaseInfo.getDatabasePath()).")
            
            return true
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
                print("SqliteDatabaseInitialisation: failed executing metadata statements --> \(metadataSQLStatements)")
                
                return false
            }
        }
        
        if let tableSQLStatements = tableSQLStatements() {
            guard database.executeStatements(tableSQLStatements) else  {
                print("SqliteDatabaseInitialisation: failed executing table statements --> \(tableSQLStatements)")
                
                return false
            }
        }
        
        if let viewSQLStatements = viewSQLStatements() {
            guard database.executeStatements(viewSQLStatements) else  {
                print("SqliteDatabaseInitialisation: failed executing view statements --> \(viewSQLStatements)")
                
                return false
            }
        }
        
        if let indexSQLStatements = indexSQLStatements() {
            guard database.executeStatements(indexSQLStatements) else  {
                print("SqliteDatabaseInitialisation: failed executing index statements --> \(indexSQLStatements)")
                
                return false
            }
        }
        
        if let triggerSQLStatements = triggerSQLStatements() {
            guard database.executeStatements(triggerSQLStatements) else  {
                print("SqliteDatabaseInitialisation: failed executing trigger statements --> \(triggerSQLStatements)")
                
                return false
            }
        }
        
        return true
    }
    
    public func databaseExists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
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
    
}
