//
//  SqliteDatabaseServiceTests_Update.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 17/03/2017.
//  Copyright © 2017 InBetweeners. All rights reserved.
//

import XCTest
import SqliteDatabase

class SqliteDatabaseServiceTests_Update: XCTestCase {
    
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
    
    func test_ExecuteUpdateSync() {
        let updateColumnValuePairs = [
            SqliteDatabaseUpdateColumnValuePair(column: "Description", value: "Feed the cat")
        ]
        
        let update = SqliteDatabaseUpdate<Todo>(columnValuePairs: updateColumnValuePairs, whereClause: "Completed = 0")
        let success = service.execute(update: update)
        
        XCTAssert(success, "The update should succeed.")
    }
    
    func test_ExecuteUpdateAsync() {
        var _success = false
        
        let updateColumnValuePairs = [
            SqliteDatabaseUpdateColumnValuePair(column: "Description", value: "Feed the cat")
        ]
        
        let update = SqliteDatabaseUpdate<Todo>(columnValuePairs: updateColumnValuePairs, whereClause: "Completed = 0")
        service.execute(update: update) { (success) in
            _success = success
        }
        
        XCTAssert(_success, "The update should succeed.")
    }
    
}
