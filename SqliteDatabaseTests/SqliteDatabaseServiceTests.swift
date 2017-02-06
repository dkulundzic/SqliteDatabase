//
//  SqliteDatabaseServiceTests.swift
//  SqliteDatabase
//
//  Created by Domagoj Kulundžić on 03/02/17.
//  Copyright © 2017 Farmeron. All rights reserved.
//

import XCTest
import SqliteDatabase

class SqliteDatabaseServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_Generic() {
        let databaseInfo = SqliteDatabaseInfo()
        SqliteDatabaseInitialisation(databaseInfo: databaseInfo, databaseDefinition: DefaultDefinition())
            .initialise { (error) in
                if let error = error, error != .alreadyExists {
                    return
                }
                
                let query = SqliteDatabaseQuery<Todo>()
                let service = SqliteDatabaseService(databaseInfo: databaseInfo)
                service.executeQuery(query: query, completion: { (rows) in
                    let todos = rows.flatMap({ Todo(row: $0) })
                    print(todos)
                })
        }
    }
    
    //    func test_ExecuteQueryWithoutTransform() {
    //        // Arrange
    //        let testExpectation = expectation(description: "ExecuteQueryWithoutTransform")
    //
    //        let query = SqliteDatabaseQuery<Todo>()
    //
    //        let databaseInfo = SqliteDatabaseInfo(userIdentifier: "")
    //        let service = SqliteDatabaseService(databaseInfo: databaseInfo)
    //
    //        // Act
    //        service.executeQuery(query: query) { (rows) in
    //            let todos = rows.flatMap(
    //                Todo.init
    //            )
    //
    //            // Assert
    //            XCTAssert(todos.count == 3, "There should be three Todos returned.")
    //            testExpectation.fulfill()
    //        }
    //
    //        waitForExpectations(timeout: 1.0) { (error) in
    //            if let error = error {
    //                print(error.localizedDescription)
    //            }
    //        }
    //    }
    //
    //    func test_ExecuteQueryWithTransform() {
    //        let testExpectation = expectation(description: "ExecuteQueryWithTransform")
    //
    //        let query = SqliteDatabaseQuery<Todo>()
    //        let transform = SqliteDatabaseRowTransform<[Todo]> { (rows) -> [Todo] in
    //            return rows.flatMap({ Todo(row: $0) })
    //        }
    //
    //        let databaseInfo = SqliteDatabaseInfo(userIdentifier: "")
    //        let service = SqliteDatabaseService(databaseInfo: databaseInfo)
    //
    //        service.executeQuery(query: query, transform: transform) { (todos) in
    //            guard let firstTodo = todos.first else {
    //                XCTAssert(true)
    //
    //                return
    //            }
    //
    //            XCTAssert(firstTodo.description == "Test1" && firstTodo.completed == true, "Incorrect Todo retrieved.")
    //        }
    //
    //        service.executeQuery(query: query) { (rows) in
    //            let todos = rows.flatMap(
    //                Todo.init
    //            )
    //
    //            XCTAssert(todos.count == 3, "There should be three Todos returned.")
    //            testExpectation.fulfill()
    //        }
    //
    //        waitForExpectations(timeout: 1.0) { (error) in
    //            if let error = error {
    //                print(error.localizedDescription)
    //            }
    //        }
    //    }
    
}
