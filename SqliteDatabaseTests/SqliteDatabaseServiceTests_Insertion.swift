//
//  SqliteDatabaseServiceTests_Insertion.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 17/03/2017.
//  Copyright © 2017 InBetweeners. All rights reserved.
//

import XCTest
import SqliteDatabase

class SqliteDatabaseServiceTests_Insertion: XCTestCase {
    
    let databaseInfo = SqliteDatabaseInfo(databaseIdentifier: "")
    var service: SqliteDatabaseService!
    
    override func setUp() {
        super.setUp()
        
        let databaseDefinition = SqliteDatabaseDefinitionBuilder()
            .with(tablesDefinition: [
                "CREATE TABLE TODO (Id INTEGER PRIMARY KEY, Description TEXT, Completed INTEGER);"
                ])
            .build()
        
        let _ = SqliteDatabaseInitialisation(databaseDefinition: databaseDefinition)
            .initialise(withDatabaseInfo: databaseInfo)
        service = SqliteDatabaseService(databaseInfo: databaseInfo)
    }
    
    override func tearDown() {
        super.tearDown()
        
        let _ = SqliteDatabaseUtility.remove(atPath: databaseInfo.getDatabasePath())
    }
    
    func test_ExecuteInsertionSync() {
        let todo = Todo(description: "Feed the cat")
        
        let insertion = SqliteDatabaseInsert<Todo>(mappable: todo)
        let rowId = service.execute(insert: insertion)
        
        XCTAssertNotNil(rowId, "The insertion should succeed.")
    }
    
    func test_ExecuteInsertionAsync() {
        var rowId: Int64?
        let todo = Todo(description: "Feed the cat")
        let insertion = SqliteDatabaseInsert<Todo>(mappable: todo)
        
        service.execute(insert: insertion) { (insertedRowId) in
            rowId = insertedRowId
        }
        
        XCTAssertNotNil(rowId, "The insertion should succeed.")
    }
    
}
