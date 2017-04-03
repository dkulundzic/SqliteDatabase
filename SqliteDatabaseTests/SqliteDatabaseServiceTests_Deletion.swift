//
//  SqliteDatabaseServiceTests_Deletion.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 16/03/2017.
//  Copyright © 2017 InBetweeners. All rights reserved.
//

import XCTest
import SqliteDatabase

class SqliteDatabaseServiceTests_Deletion: XCTestCase {
    
    let databaseInfo = SqliteDatabaseInfo(databaseIdentifier: "")
    var service: SqliteDatabaseService!
    
    override func setUp() {
        super.setUp()
        
        let databaseDefinition = SqliteDatabaseDefinitionBuilder()
            .with(tablesDefinition: [
                "CREATE TABLE TODO (Id INTEGER PRIMARY KEY, Description TEXT, Completed INTEGER);"
                ])
            .with(postCreationStatements: [
                "INSERT INTO Todo (Description, Completed) VALUES ('Feed the cat', 0);",
                "INSERT INTO Todo (Description, Completed) VALUES ('Bar the gates', 0);",
                "INSERT INTO Todo (Description, Completed) VALUES ('Feed the elephant', 1);"
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
    
    func test_ExecuteDeletion_Sync() {
        let deletion = SqliteDatabaseDelete<Todo>(whereClause: "Completed == 1")
        let success = service.execute(delete: deletion)
        
        XCTAssert(success, "The deletion should succeed.")
    }
    
    func test_ExecuteDeletion_Async() {
        let deletion = SqliteDatabaseDelete<Todo>(whereClause: "Completed == 1")
        service.execute(delete: deletion) { (success) in
            XCTAssert(success, "The deletion should succeed.")
        }
    }
}
