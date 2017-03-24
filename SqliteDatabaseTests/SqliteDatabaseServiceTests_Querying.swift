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
        service.isLogging = false
    }
    
    override func tearDown() {
        super.tearDown()
        
        let _ = SqliteDatabaseInitialisation(databaseDefinition: DatabaseDefinition())
            .remove(at: databaseInfo.getDatabasePath())
    }
    
    func test_ExecuteQueryWithoutTransform() {
        // Arrange
        let query = SqliteDatabaseQuery<Todo>()
        
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
        
        service.execute(query: query, transform: transform) { (todos) in
            XCTAssert(todos.count > 0, "There should be todos returned.")
        }
    }
    
    func test_ExecuteQueryWithWhereClause() {
        let query = SqliteDatabaseQuery<Todo>(whereClause: "Completed = 1")
        
        service.execute(query: query) { (rows) in
            let todos = rows.flatMap(
                Todo.init
            )
            XCTAssert(todos.count == 1, "There shouldn be one todo returned.")
        }
    }
    
}
