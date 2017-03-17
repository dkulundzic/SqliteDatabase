//
//  SqliteDatabaseSqlBuilder.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 17/03/2017.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import XCTest
import SqliteDatabase

class SqliteDatabaseSqlBuilderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_QuerySqlStatementCreationWithoutWhereClause() {
        let query = SqliteDatabaseQuery<Todo>()
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
                
        XCTAssert(sqlStatement.lowercased() == "SELECT Description,Completed FROM Todo".lowercased(), "The created sql QUERY statement is incorrect.")
    }
    
    func test_QuerySqlStatementCreationWithWhereClause() {
        let query = SqliteDatabaseQuery<Todo>(whereClause: "Completed == 1")
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        XCTAssert(sqlStatement.lowercased() == "SELECT Description,Completed FROM Todo WHERE Completed == 1".lowercased(), "The created QUERY sql statement is incorrect.")
    }
    
}
