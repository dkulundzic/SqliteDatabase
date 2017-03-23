//
//  SqliteDatabaseSqlBuilder.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundzic on 17/03/2017.
//  Copyright © 2017 InBetweeners. All rights reserved.
//

import XCTest
import SqliteDatabase

class SqliteDatabaseSqlBuilderTests: XCTestCase {
    
    // MARK: - 
    // MARK: Query tests
    // MARK: -
    
    func test_QuerySqlStatementCreation() {
        let query = SqliteDatabaseQuery<Todo>()
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
                
        XCTAssert(sqlStatement.lowercased() == "SELECT Description,Completed FROM Todo;".lowercased(), "The created sql QUERY statement is invalid.")
    }
    
    func test_QuerySqlStatementCreationWithWhereClause() {
        let query = SqliteDatabaseQuery<Todo>(whereClause: "Completed = 1")
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        XCTAssert(sqlStatement.lowercased() == "SELECT Description,Completed FROM Todo WHERE Completed = 1;".lowercased(), "The created QUERY sql statement is invalid.")
    }
    
    func test_QuerySqlStatementCreationWithLimitClause() {
        let limit = 5
        let query = SqliteDatabaseQuery<Todo>(limit: limit)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        XCTAssert(sqlStatement.lowercased() == "SELECT Description,Completed FROM Todo LIMIT \(limit);".lowercased(), "The created QUERY sql statement is invalid.")
    }
    
    func test_QuerySqlStatementCreationWithWhereAndLimitClause() {
        let limit = 3
        let query = SqliteDatabaseQuery<Todo>(whereClause: "Completed = 1", limit: limit)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        XCTAssert(sqlStatement.lowercased() == "SELECT Description,Completed FROM Todo WHERE Completed = 1 LIMIT \(limit);".lowercased(), "The created QUERY sql statement is invalid.")
    }
    
    func test_QuerySqlStatementCreationWithInnerJoins() {
        let innerJoins = [
            SqliteDatabaseQueryJoin(joinType: .inner, tableName: "Users", joinPredicate: "t.UserId = u.Id"),
            SqliteDatabaseQueryJoin(joinType: .inner, tableName: "Tags", joinPredicate: "t.Id = tgs.TodoId")
        ]
        
        let query = SqliteDatabaseQuery<Todo>(joins: innerJoins)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        let expectedSqlStatement = "SELECT Description,Completed FROM Todo INNER JOIN Users ON t.UserId = u.Id INNER JOIN Tags ON t.Id = tgs.TodoId;"
        
        XCTAssert(sqlStatement.lowercased() == expectedSqlStatement.lowercased(), "The created QUERY sql statement is invalid.")
    }
    
    func test_QuerySqlStatementCreationWithInnerJoinsAndWhereClause() {
        let innerJoins = [
            SqliteDatabaseQueryJoin(joinType: .inner, tableName: "Users", joinPredicate: "t.UserId = u.Id"),
            SqliteDatabaseQueryJoin(joinType: .inner, tableName: "Tags", joinPredicate: "t.Id = tgs.TodoId")
        ]
        
        let query = SqliteDatabaseQuery<Todo>(whereClause: "Completed = 1", joins: innerJoins)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        let expectedSqlStatement = "SELECT Description,Completed FROM Todo INNER JOIN Users ON t.UserId = u.Id INNER JOIN Tags ON t.Id = tgs.TodoId WHERE Completed = 1;"
        
        XCTAssert(sqlStatement.lowercased() == expectedSqlStatement.lowercased(), "The created QUERY sql statement is invalid.")
    }
    
    func test_QuerySqlStatementCreationWithInnerJoinsAndLimitClause() {
        let limit = 5
        let innerJoins = [
            SqliteDatabaseQueryJoin(joinType: .inner, tableName: "Users", joinPredicate: "t.UserId = u.Id"),
            SqliteDatabaseQueryJoin(joinType: .inner, tableName: "Tags", joinPredicate: "t.Id = tgs.TodoId")
        ]
        
        let query = SqliteDatabaseQuery<Todo>(limit: limit, joins: innerJoins)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        let expectedSqlStatement = "SELECT Description,Completed FROM Todo INNER JOIN Users ON t.UserId = u.Id INNER JOIN Tags ON t.Id = tgs.TodoId LIMIT \(limit);"
        
        XCTAssert(sqlStatement.lowercased() == expectedSqlStatement.lowercased(), "The created QUERY sql statement is invalid.")
    }
    
    func test_QuerySqlStatementCreationWithInnerJoinsAndBothWhereAndLimitClause() {
        let limit = 5
        let innerJoins = [
            SqliteDatabaseQueryJoin(joinType: .inner, tableName: "Users", joinPredicate: "t.UserId = u.Id"),
            SqliteDatabaseQueryJoin(joinType: .inner, tableName: "Tags", joinPredicate: "t.Id = tgs.TodoId")
        ]
        
        let query = SqliteDatabaseQuery<Todo>(whereClause: "Completed = 1", limit: limit, joins: innerJoins)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        let expectedSqlStatement = "SELECT Description,Completed FROM Todo INNER JOIN Users ON t.UserId = u.Id INNER JOIN Tags ON t.Id = tgs.TodoId WHERE Completed = 1 LIMIT \(limit);"
        
        XCTAssert(sqlStatement.lowercased() == expectedSqlStatement.lowercased(), "The created QUERY sql statement is invalid.")
    }
    
    func test_QuerySqlStatementCreationWithLeftJoins() {
        let leftJoins = [
            SqliteDatabaseQueryJoin(joinType: .left, tableName: "Users", joinPredicate: "t.UserId = u.Id"),
            SqliteDatabaseQueryJoin(joinType: .left, tableName: "Tags", joinPredicate: "t.Id = tgs.TodoId")
        ]
        
        let query = SqliteDatabaseQuery<Todo>(joins: leftJoins)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        let expectedSqlStatement = "SELECT Description,Completed FROM Todo LEFT JOIN Users ON t.UserId = u.Id LEFT JOIN Tags ON t.Id = tgs.TodoId;"
        
        XCTAssert(sqlStatement.lowercased() == expectedSqlStatement.lowercased(), "The created QUERY sql statement is invalid.")
    }
    
    func test_QuerySqlStatementCreationWithLeftJoinsAndWhereClause() {
        let leftJoins = [
            SqliteDatabaseQueryJoin(joinType: .left, tableName: "Users", joinPredicate: "t.UserId = u.Id"),
            SqliteDatabaseQueryJoin(joinType: .left, tableName: "Tags", joinPredicate: "t.Id = tgs.TodoId")
        ]
        
        let query = SqliteDatabaseQuery<Todo>(whereClause: "Completed = 1", joins: leftJoins)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        let expectedSqlStatement = "SELECT Description,Completed FROM Todo LEFT JOIN Users ON t.UserId = u.Id LEFT JOIN Tags ON t.Id = tgs.TodoId WHERE Completed = 1;"
        
        XCTAssert(sqlStatement.lowercased() == expectedSqlStatement.lowercased(), "The created QUERY sql statement is invalid.")
    }
    
    func test_QuerySqlStatementCreationWithLeftJoinsAndLimitClause() {
        let limit = 5
        let leftJoins = [
            SqliteDatabaseQueryJoin(joinType: .left, tableName: "Users", joinPredicate: "t.UserId = u.Id"),
            SqliteDatabaseQueryJoin(joinType: .left, tableName: "Tags", joinPredicate: "t.Id = tgs.TodoId")
        ]
        
        let query = SqliteDatabaseQuery<Todo>(limit: limit, joins: leftJoins)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        let expectedSqlStatement = "SELECT Description,Completed FROM Todo LEFT JOIN Users ON t.UserId = u.Id LEFT JOIN Tags ON t.Id = tgs.TodoId LIMIT \(limit);"
        
        XCTAssert(sqlStatement.lowercased() == expectedSqlStatement.lowercased(), "The created QUERY sql statement is invalid.")
    }
    
    func test_QuerySqlStatementCreationWithLeftJoinsAndBothWhereAndLimitClause() {
        let limit = 5
        let innerJoins = [
            SqliteDatabaseQueryJoin(joinType: .left, tableName: "Users", joinPredicate: "t.UserId = u.Id"),
            SqliteDatabaseQueryJoin(joinType: .left, tableName: "Tags", joinPredicate: "t.Id = tgs.TodoId")
        ]
        
        let query = SqliteDatabaseQuery<Todo>(whereClause: "Completed = 1", limit: limit, joins: innerJoins)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        let expectedSqlStatement = "SELECT Description,Completed FROM Todo LEFT JOIN Users ON t.UserId = u.Id LEFT JOIN Tags ON t.Id = tgs.TodoId WHERE Completed = 1 LIMIT \(limit);"
        
        XCTAssert(sqlStatement.lowercased() == expectedSqlStatement.lowercased(), "The created QUERY sql statement is invalid.")
    }
    
    func test_QuerySqlStatementCreationWithInnerAndLeftJoins() {
        let innerJoins = [
            SqliteDatabaseQueryJoin(joinType: .inner, tableName: "Users", joinPredicate: "t.UserId = u.Id"),
            SqliteDatabaseQueryJoin(joinType: .inner, tableName: "Tags", joinPredicate: "t.Id = tgs.TodoId")
        ]
        
        let leftJoins = [
            SqliteDatabaseQueryJoin(joinType: .left, tableName: "Users", joinPredicate: "t.UserId = u.Id"),
            SqliteDatabaseQueryJoin(joinType: .left, tableName: "Tags", joinPredicate: "t.Id = tgs.TodoId")
        ]
        
        let joins = innerJoins + leftJoins
        
        let query = SqliteDatabaseQuery<Todo>(joins: joins)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        let expectedSqlStatement = "SELECT Description,Completed FROM Todo INNER JOIN Users ON t.UserId = u.Id INNER JOIN Tags ON t.Id = tgs.TodoId LEFT JOIN Users ON t.UserId = u.Id LEFT JOIN Tags ON t.Id = tgs.TodoId;"
        
        XCTAssert(sqlStatement.lowercased() == expectedSqlStatement.lowercased(), "The created QUERY sql statement is invalid.")
    }
    
    func test_QuerySqlStatementCreationWithInnerAndLeftJoinsAndWhereClause() {
        let innerJoins = [
            SqliteDatabaseQueryJoin(joinType: .inner, tableName: "Users", joinPredicate: "t.UserId = u.Id"),
            SqliteDatabaseQueryJoin(joinType: .inner, tableName: "Tags", joinPredicate: "t.Id = tgs.TodoId")
        ]
        
        let leftJoins = [
            SqliteDatabaseQueryJoin(joinType: .left, tableName: "Users", joinPredicate: "t.UserId = u.Id"),
            SqliteDatabaseQueryJoin(joinType: .left, tableName: "Tags", joinPredicate: "t.Id = tgs.TodoId")
        ]
        
        let joins = innerJoins + leftJoins
        
        let query = SqliteDatabaseQuery<Todo>(whereClause: "Completed = 1", joins: joins)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        let expectedSqlStatement = "SELECT Description,Completed FROM Todo INNER JOIN Users ON t.UserId = u.Id INNER JOIN Tags ON t.Id = tgs.TodoId LEFT JOIN Users ON t.UserId = u.Id LEFT JOIN Tags ON t.Id = tgs.TodoId WHERE Completed = 1;"
        
        XCTAssert(sqlStatement.lowercased() == expectedSqlStatement.lowercased(), "The created QUERY sql statement is invalid.")
    }
    
    func test_QuerySqlStatementCreationWithInnerAndLeftJoinsAndWhereClauseAndLimitClause() {
        let limit = 5
        let innerJoins = [
            SqliteDatabaseQueryJoin(joinType: .inner, tableName: "Users", joinPredicate: "t.UserId = u.Id"),
            SqliteDatabaseQueryJoin(joinType: .inner, tableName: "Tags", joinPredicate: "t.Id = tgs.TodoId")
        ]
        
        let leftJoins = [
            SqliteDatabaseQueryJoin(joinType: .left, tableName: "Users", joinPredicate: "t.UserId = u.Id"),
            SqliteDatabaseQueryJoin(joinType: .left, tableName: "Tags", joinPredicate: "t.Id = tgs.TodoId")
        ]
        
        let joins = innerJoins + leftJoins
        
        let query = SqliteDatabaseQuery<Todo>(whereClause: "Completed = 1", limit: limit, joins: joins)
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forQuery: query)
        
        let expectedSqlStatement = "SELECT Description,Completed FROM Todo INNER JOIN Users ON t.UserId = u.Id INNER JOIN Tags ON t.Id = tgs.TodoId LEFT JOIN Users ON t.UserId = u.Id LEFT JOIN Tags ON t.Id = tgs.TodoId WHERE Completed = 1 LIMIT \(5);"
        
        XCTAssert(sqlStatement.lowercased() == expectedSqlStatement.lowercased(), "The created QUERY sql statement is invalid.")
    }
    
    // MARK: -
    // MARK: Insert tests
    // MARK: -
    
    func test_InsertSqlStatementCreation() {
        let todo = Todo(description: "Feed the cat", completed: true)
        let insert = SqliteDatabaseInsert(mappable: todo)
        
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forInsert: insert)
        let expectedStatement = "INSERT INTO Todo (Description,Completed) VALUES (?,?);"
        
        XCTAssert(sqlStatement == expectedStatement, "The created INSERT sql statement is invalid.")
    }
    
    func test_InsertSqlStatementCreationWithShouldReplace() {
        let todo = Todo(description: "Feed the cat", completed: true)
        let insert = SqliteDatabaseInsert(mappable: todo, shouldReplace: true)
        
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forInsert: insert)
        let expectedStatement = "INSERT OR REPLACE INTO Todo (Description,Completed) VALUES (?,?);"
        
        XCTAssert(sqlStatement == expectedStatement, "The created INSERT sql statement is invalid.")
    }
    
    // MARK: -
    // MARK: Update tests
    // MARK: -
    
    func test_UpdateSqlStatementCreation() {
        let updateColumnValuePairs = [
            SqliteDatabaseUpdateColumnValuePair(column: "Completed", value: true),
            SqliteDatabaseUpdateColumnValuePair(column: "Description", value: "Feed the dog.")
        ]
        
        let update = SqliteDatabaseUpdate<Todo>(columnValuePairs: updateColumnValuePairs, whereClause: "Id = 1")
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forUpdate: update)
        let expectedStatement = "UPDATE Todo SET Completed = ?, Description = ? WHERE Id = 1;"
        
        XCTAssert(sqlStatement.lowercased() == expectedStatement.lowercased(), "The created sql UPDATE statement is invalid.")
    }
    
    // MARK: -
    // MARK: Delete tests
    // MARK: -
    
    func test_DeleteSqlStatementCreation() {
        let delete = SqliteDatabaseDelete<Todo>(whereClause: "Completed == 0")
        
        let sqlStatement = SqliteDatabaseSqlBuilder().build(forDelete: delete)
        let expectedStatement = "DELETE FROM Todo WHERE Completed == 0;"
        
        XCTAssert(sqlStatement.lowercased() == expectedStatement.lowercased(), "The created sql DELETE statement is invalid.")
    }
}
