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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_ExecuteDeletion_Sync() {
        let databaseInfo = SqliteDatabaseInfo(userIdentifier: "")
        let databaseService = SqliteDatabaseService(databaseInfo: databaseInfo)
        
        let deletion = SqliteDatabaseDelete<Todo>(whereClause: "Completed = 1")
        let success = databaseService.execute(delete: deletion)
        
        XCTAssert(!success, "The deletion should fail.")
    }
    
    func test_ExecuteDeletion_Async() {
        let databaseInfo = SqliteDatabaseInfo(userIdentifier: "")
        let databaseService = SqliteDatabaseService(databaseInfo: databaseInfo)
        
        let deletion = SqliteDatabaseDelete<Todo>(whereClause: "Completed = 1")
        databaseService.execute(delete: deletion) { (success) in
            XCTAssert(!success, "The deletion should fail.")
        }
    }
}
