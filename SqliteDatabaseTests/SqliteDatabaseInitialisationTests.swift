//
//  SqliteDatabaseInitialisationTests.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 23/03/2017.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import XCTest
import SqliteDatabase

class SqliteDatabaseInitialisationTests: XCTestCase {
    
    func test_DatabaseInitialisation() {
        let databaseInitialisation = SqliteDatabaseInitialisation(
            databaseDefinition: DatabaseDefinition()
        )
        
        let success = databaseInitialisation.initialise(
            withDatabaseInfo: SqliteDatabaseInfo(userIdentifier: "")
        )
        
        XCTAssert(success, "The database initialisation should succeed.")
    }
    
    func test_DatabaseInitialisation_BuildableDefinition_EmptyStatements() {
        let databaseDefinition = SqliteDatabaseDefinitionBuilder()
            .with(tablesDefinition: [])
            .with(metadataDefinition: [])
            .with(viewsDefinition: [])
            .with(indicesDefinition: [])
            .with(triggersDefinition: [])
            .build()
        
        let databaseInitialisation = SqliteDatabaseInitialisation(
            databaseDefinition: databaseDefinition
        )
        
        let success = databaseInitialisation.initialise(
            withDatabaseInfo: SqliteDatabaseInfo(userIdentifier: "")
        )
        
        XCTAssert(success, "The database initialisation should succeed.")
    }
    
    func test_DatabaseInitialisation_BuildableDefinition_ValidStatements() {
        let databaseDefinition = SqliteDatabaseDefinitionBuilder()
            .with(tablesDefinition: ["CREATE TABLE Todo (Id INTEGER PRIMARY KEY, Description TEXT, Completed INTEGER, Updated TEXT);"])
            .with(triggersDefinition: ["CREATE TRIGGER Todo_Update AFTER UPDATE ON Todo BEGIN UPDATE Todo SET Updated = datetime('now'); END;"])
            .build()
        
        let databaseInitialisation = SqliteDatabaseInitialisation(
            databaseDefinition: databaseDefinition
        )
        
        let success = databaseInitialisation.initialise(
            withDatabaseInfo: SqliteDatabaseInfo(userIdentifier: "")
        )
        
        XCTAssert(success, "The database initialisation should succeed.")
    }
}
