//
//  SqliteDatabaseServiceTests.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 InBetweeners. All rights reserved.
//

import XCTest
import SqliteDatabase

class SqliteDatabaseServiceTests: XCTestCase {
    
    let databaseInfo = SqliteDatabaseInfo(userIdentifier: "")
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_ExecuteQueryWithoutTransform() {
        // Arrange
        let query = SqliteDatabaseQuery<Todo>()
        let service = SqliteDatabaseService(databaseInfo: databaseInfo)
        
        // Act
        service.execute(query: query) { (rows) in
            let todos = rows.flatMap(
                Todo.init
            )
            
            // Assert
            XCTAssert(todos.count > 0, "There should be todos returned.")
        }
    }
    
    func test_ExecuteQueryWithTransform() {
        let query = SqliteDatabaseQuery<Todo>()
        let transform = SqliteDatabaseRowTransform<[Todo]> { (rows) -> [Todo] in
            return rows.flatMap({ Todo(row: $0) })
        }
        
        let service = SqliteDatabaseService(databaseInfo: databaseInfo)
        
        service.execute(query: query, transform: transform) { (todos) in
            XCTAssert(todos.count > 0, "There shouldn be todos returned.")
        }
    }
    
    func test_ExecuteQueryWithWhereClause() {
        let query = SqliteDatabaseQuery<Todo>(whereClause: "Completed = 1")
        
        let databaseInfo = SqliteDatabaseInfo(userIdentifier: "")
        let service = SqliteDatabaseService(databaseInfo: databaseInfo)
        
        service.execute(query: query) { (rows) in
            let todos = rows.flatMap(
                Todo.init
            )
            XCTAssert(todos.count == 0, "There shouldn't be any todos returned.")
        }
    }

}
