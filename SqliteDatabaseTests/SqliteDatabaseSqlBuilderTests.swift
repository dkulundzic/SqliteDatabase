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
    
    func test_QuerySqlStatementCreation() {
        let query = SqliteDatabaseQuery<Todo>()
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
                
        XCTAssert(sqlStatement.lowercased() == "SELECT Description,Completed FROM Todo;".lowercased(), "The created sql QUERY statement is incorrect.")
    }
    
    func test_QuerySqlStatementCreationWithWhereClause() {
        let query = SqliteDatabaseQuery<Todo>(whereClause: "Completed = 1")
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        XCTAssert(sqlStatement.lowercased() == "SELECT Description,Completed FROM Todo WHERE Completed = 1;".lowercased(), "The created QUERY sql statement is incorrect.")
    }
    
    func test_QuerySqlStatementCreationWithLimitClause() {
        let limit = 5
        let query = SqliteDatabaseQuery<Todo>(limit: limit)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        XCTAssert(sqlStatement.lowercased() == "SELECT Description,Completed FROM Todo LIMIT \(limit);".lowercased(), "The created QUERY sql statement is incorrect.")
    }
    
    func test_QuerySqlStatementCreationWithInnerJoins() {
        let innerJoins = [
            SqliteDatabaseQueryInnerJoin(tableName: "Users", joinPredicate: "t.UserId = u.Id"),
            SqliteDatabaseQueryInnerJoin(tableName: "Tags", joinPredicate: "t.Id = tgs.TodoId")
        ]
        
        let query = SqliteDatabaseQuery<Todo>(innerJoins: innerJoins)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        let expectedSqlStatement = "SELECT Description,Completed FROM Todo INNER JOIN Users ON t.UserId = u.Id INNER JOIN Tags ON t.Id = tgs.TodoId;"
        
        XCTAssert(sqlStatement.lowercased() == expectedSqlStatement.lowercased(), "The created QUERY sql statement is incorrect.")
    }
    
    func test_QuerySqlStatementCreationWithWhereAndLimitClause() {
        let limit = 3
        let query = SqliteDatabaseQuery<Todo>(whereClause: "Completed = 1", limit: limit)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        XCTAssert(sqlStatement.lowercased() == "SELECT Description,Completed FROM Todo WHERE Completed = 1 LIMIT \(limit);".lowercased(), "The created QUERY sql statement is incorrect.")
    }
    
    func test_QuerySqlStatementCreationWithInnerJoinsAndWhereClause() {
        let innerJoins = [
            SqliteDatabaseQueryInnerJoin(tableName: "Users", joinPredicate: "t.UserId = u.Id"),
            SqliteDatabaseQueryInnerJoin(tableName: "Tags", joinPredicate: "t.Id = tgs.TodoId")
        ]
        
        let query = SqliteDatabaseQuery<Todo>(whereClause: "Completed = 1", innerJoins: innerJoins)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        let expectedSqlStatement = "SELECT Description,Completed FROM Todo INNER JOIN Users ON t.UserId = u.Id INNER JOIN Tags ON t.Id = tgs.TodoId WHERE Completed = 1;"
        
        XCTAssert(sqlStatement.lowercased() == expectedSqlStatement.lowercased(), "The created QUERY sql statement is incorrect.")
    }
    
    func test_QuerySqlStatementCreationWithInnerJoinsAndLimitClause() {
        let limit = 5
        let innerJoins = [
            SqliteDatabaseQueryInnerJoin(tableName: "Users", joinPredicate: "t.UserId = u.Id"),
            SqliteDatabaseQueryInnerJoin(tableName: "Tags", joinPredicate: "t.Id = tgs.TodoId")
        ]
        
        let query = SqliteDatabaseQuery<Todo>(limit: limit, innerJoins: innerJoins)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        let expectedSqlStatement = "SELECT Description,Completed FROM Todo INNER JOIN Users ON t.UserId = u.Id INNER JOIN Tags ON t.Id = tgs.TodoId LIMIT \(limit);"
        
        XCTAssert(sqlStatement.lowercased() == expectedSqlStatement.lowercased(), "The created QUERY sql statement is incorrect.")
    }
}
