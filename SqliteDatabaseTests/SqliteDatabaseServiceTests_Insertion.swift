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
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_ExecuteInsertionSync() {
        let databaseInfo = SqliteDatabaseInfo(userIdentifier: "")
        let databaseService = SqliteDatabaseService(databaseInfo: databaseInfo)
        
        let todo = Todo(description: "Feed the cat")
        
        let insertion = SqliteDatabaseInsert<Todo>(mappable: todo)
        let success = databaseService.execute(insert: insertion)
        
        XCTAssert(!success, "The insertion should fail.")
    }
    
    func test_ExecuteInsertionAsync() {
        let databaseInfo = SqliteDatabaseInfo(userIdentifier: "")
        let databaseService = SqliteDatabaseService(databaseInfo: databaseInfo)
        
        var _success = false
        let todo = Todo(description: "Feed the cat")
        let insertion = SqliteDatabaseInsert<Todo>(mappable: todo)
        
        databaseService.execute(insert: insertion) { (success) in
            _success = success
        }
        
        XCTAssert(!_success, "The insertion should fail.")
    }
    
}
