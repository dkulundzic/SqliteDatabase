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
    
    private let databaseInfo = SqliteDatabaseInfo()
    private var service: SqliteDatabaseService!
    
    override func setUp() {
        super.setUp()
        
        SqliteDatabaseInitialisation(databaseInfo: databaseInfo, databaseDefinition: DefaultDefinition())
            .initialise { (error) in
                if let error = error, error != .alreadyExists {
                    return
                }
        }
        
        service = SqliteDatabaseService(databaseInfo: databaseInfo)
    }
    
    override func tearDown() {
        super.tearDown()
        
        do {
            try FileManager.default.removeItem(at:
                URL(fileURLWithPath: databaseInfo.getDatabasePath())
            )
        } catch {
            print("Failed removing the database.")
        }
    }
    
    func test_Insertion() {
        let todo = Todo(id: "98XDS-DA1D3-DSAQ9", description: "Read a good book")
        let insert = SqliteDatabaseInsert(mappable: todo)
        
        var success = false
        
        service.executeUpdate(update: insert, completion: { (result) in
            success = result
        })
        
        if success {
            self.service.executeQuery(query: SqliteDatabaseQuery<Todo>(whereClause: "Id = '\(todo.id)'")) { (rows) in
                XCTAssert(rows.count == 1, "As the service returned \"true\", the specified row should be present in the database, but was not found.")
            }
        } else {
            self.service.executeQuery(query: SqliteDatabaseQuery<Todo>(whereClause: "Id = '\(todo.id)'")) { (rows) in
                XCTAssert(rows.count == 0, "As the service returned \"false\", the specified row should not be present in the database, but was found.")
            }
        }
    }
    
    func test_Deletion() {
        let delete = SqliteDatabaseDelete<Todo>(whereClause: "1 = 1")
        
        service.executeUpdate(update: delete) { (_) in }
        service.executeQuery(query: SqliteDatabaseQuery<Todo>()) { (rows) in
            XCTAssert(rows.count == 0, "The delete was unsuccessful.")
        }
    }
}
