//
//  SqliteDatabaseDefinitionBuilderTests.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 23/03/2017.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import XCTest
import SqliteDatabase

class SqliteDatabaseDefinitionBuilderTests: XCTestCase {
    
    func test_BuildableDefinitionCreation() {
        let tablesDefinition = ["CREATE TABLE Todo (Id INTEGER PRIMARY KEY, Description TEXT, Completed INTEGER, Updated TEXT);"]
        let triggersDefinition = ["CREATE TRIGGER Todo_Update AFTER UPDATE ON Todo BEGIN UPDATE Todo SET Updated = datetime('now'); END;"]
        
        let databaseDefinition = SqliteDatabaseDefinitionBuilder()
            .with(tablesDefinition: tablesDefinition)
            .with(triggersDefinition: triggersDefinition)
            .build()
        
        XCTAssert(databaseDefinition.metadataDefinition.count == 0, "The metadata was not set, so it should have zero elements.")
        XCTAssert(databaseDefinition.tablesDefinition == tablesDefinition, "The tables list was not correctly set.")
        XCTAssert(databaseDefinition.viewsDefinition.count == 0, "The views list was not set, so it should have zero elements.")
        XCTAssert(databaseDefinition.indicesDefinition.count == 0, "The indices list was not set, so it should have zero elements.")
        XCTAssert(databaseDefinition.triggersDefinition == triggersDefinition, "The triggers list was not correctly set.")
    }
    
}
