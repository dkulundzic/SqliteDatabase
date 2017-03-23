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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_ExecuteUpdateSync() {
        let databaseInfo = SqliteDatabaseInfo(userIdentifier: "")
        let databaseService = SqliteDatabaseService(databaseInfo: databaseInfo)
        
        let updateColumnValuePairs = [
            SqliteDatabaseUpdateColumnValuePair(column: "Description", value: "Feed the cat")
        ]
        
        let update = SqliteDatabaseUpdate<Todo>(columnValuePairs: updateColumnValuePairs, whereClause: "Completed = 0")
        
        let success = databaseService.execute(update: update)
        
        XCTAssert(!success, "The update should fail.")
    }
    
    func test_ExecuteUpdateAsync() {
        let databaseInfo = SqliteDatabaseInfo(userIdentifier: "")
        let databaseService = SqliteDatabaseService(databaseInfo: databaseInfo)
        
        var _success = false
        
        let updateColumnValuePairs = [
            SqliteDatabaseUpdateColumnValuePair(column: "Description", value: "Feed the cat")
        ]
        
        let update = SqliteDatabaseUpdate<Todo>(columnValuePairs: updateColumnValuePairs, whereClause: "Completed = 0")
        
        databaseService.execute(update: update) { (success) in
            _success = success
        }
        
        XCTAssert(!_success, "The update should fail.")
    }
    
}
