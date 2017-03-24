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
    
    let databaseInfo = SqliteDatabaseInfo(userIdentifier: "")
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
        
        let _ = SqliteDatabaseInitialisation(databaseDefinition: DatabaseDefinition())
            .remove(at: databaseInfo.getDatabasePath())
    }
    
    func test_ExecuteInsertionSync() {
        let todo = Todo(description: "Feed the cat")
        
        let insertion = SqliteDatabaseInsert<Todo>(mappable: todo)
        let success = service.execute(insert: insertion)
        
        XCTAssert(success, "The insertion should succeed.")
    }
    
    func test_ExecuteInsertionAsync() {
        var _success = false
        let todo = Todo(description: "Feed the cat")
        let insertion = SqliteDatabaseInsert<Todo>(mappable: todo)
        
        service.execute(insert: insertion) { (success) in
            _success = success
        }
        
        XCTAssert(_success, "The insertion should succeed.")
    }
    
}
